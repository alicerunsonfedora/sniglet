//
//  SnigletValidations.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 15/11/21.
//

import Foundation
import CoreML

/// A class that contains all of the business logic needed to create and validate sniglets.
class Sniglet {

    /// A class reference to a machine learning model.
    public typealias Validator = MLModel

    /// A class reference to the sniglet result type.
    public typealias Result = SnigletResult

    /// A shared instance of the Sniglet class.
    public static var shared: Sniglet { Sniglet() }

    // MARK: - PRIVATE FIELDS
    private var model: some Validator {
        switch kind {
        case .Classic:
            return try! Classic(configuration: .init()).model
        case .Fantasy:
            return try! Fantasy(configuration: .init()).model
        }
    }
    private var kind: ValidatorKind
    private var minChars: Int
    private var maxChars: Int
    private var batchSize: Int
    private var syllablicStructs: SyllableShapes

    // MARK: - CONSTRUCTOR

    init() {
        // TODO: Re-enable this once the datasets are fleshed out. In the meantime, keep this as the classic mode.
        // Set the kind from the UserDefaults so that the class can pick the correct model for predictions.
        // if let kindStr = UserDefaults.standard.string(forKey: "generateMethod") {
        //     kind = ValidatorKind(rawValue: kindStr) ?? .Classic
        // } else {
        //     UserDefaults.standard.set("Classic", forKey: "generateMethod")
        //     kind = .Classic
        // }
        kind = .Classic
        print("Init model with type: \(kind.rawValue)")

        // Grab the minimum number of letters from user preferences, or use the default value and set it.
        minChars = UserDefaults.standard.integer(forKey: "algoMinBound")
        if minChars <= 0 {
            minChars = 3
            UserDefaults.standard.set(3, forKey: "algoMinBound")
        }

        // Grab the maximum number of letters from user preferences, or use the default value and set it.
        maxChars = UserDefaults.standard.integer(forKey: "algoMaxBound")
        if maxChars <= 0 {
            maxChars = 8
            UserDefaults.standard.set(8, forKey: "algoMaxBound")
        }

        // Grab the batch size from user preferences, or use the default value and set it.
        batchSize = UserDefaults.standard.integer(forKey: "algoBatchSize")
        if batchSize <= 0 {
            batchSize = 25
            UserDefaults.standard.set(25, forKey: "algoBatchSize")
        }

        // Load the syllable shapes in from the common and custom sets.
        syllablicStructs = .common()
        if let customStructs: SyllableShapes = SyllableShapes(
            rawValue: UserDefaults.standard.string(forKey: "customShapes") ?? "") {
            syllablicStructs += customStructs
        }
    }

    // MARK: - GENERATION

    /// Returns a list of results from the sniglet validator.
    /// - Parameter count: The number of words to create.
    /// - Important: This method supports concurrency. When avaialable, use this method instead.
    public func getNewWords(count: Int = 1) async -> Set<Result> {
        return getNewWords(count: count, from: .init())
    }

    /// Returns a list of results from the sniglet validator.
    /// - Parameter count: The number of words to create.
    /// - Parameter set: The set to store the words into. Generally, this is not used from the developer and is instead used to call the method
    ///     recursively.
    public func getNewWords(count: Int = 1, from set: Set<Result> = Set()) -> Set<Result> {
        // If our existing set already has the amount of words we need, return that here.
        if set.count == count { return set }

        // If the batch size is too close to the number of words we want to generate, use a different batch size to
        // accomodate for it.
        if (..<9).contains(batchSize - count) { batchSize *= 4 }

        // Generate a batch of words.
        let generatedWords = makeWordBatch(count)

        // Create the empty word bank.
        var wordResults: Set<Result> = set

        // Try to validate all of the words against the model and return the word bank. If an error occurs, return a
        // set with an Error tag.
        do {
            // Map them to inputs that the model will be able to understand.
            let batchInput = generatedWords.map { word in word.asModelInput() }

            // Predict each result, convert them into a result format the app can use, and only keep those that are
            // valid.
            var batchResults = try validateResults(batchInput, from: generatedWords)

            // Add words until our set is complete (or until we fill in all of our options).
            while wordResults.count < count && batchResults.count > 0 {
                wordResults.update(with: batchResults.removeFirst())
            }

        } catch { return Set(arrayLiteral: .error()) }

        // Return a recursive call of this function with the new set we just created to add more, if necessary.
        return getNewWords(count: count, from: wordResults)
    }

    /// Generates a list of words with the specified count.
    private func makeWordBatch(_ count: Int) -> [String] {
        var generatedWords: [String] = []
        for _ in 0..<count {
            // Create a new word between the minimum and maximum character limits.
            var newWord = String.makeWord(limit: minChars..<maxChars, with: syllablicStructs.randomElement() ?? "CV")

            // If the word is already the maximum length of eight characters, add it to the list of words.
            if newWord.count == 8 {
                generatedWords.append(newWord)
                continue
            }

            // Otherwise, pad it with asterisks so that it matches eight characters.
            for _ in newWord.count..<8 { newWord += "*" }
            generatedWords.append(newWord)
        }
        return generatedWords
    }

    /// Returns a list of results containing words that are valid by the machine learning model.
    private func validateResults(_ batchInput: [ClassicInput], from origin: [String]) throws -> [Result] {
        // Make the predictions from the model and create an empty list of results.
        let predictions = try model.predictions(fromBatch: MLArrayBatchProvider(array: batchInput))
        var filteredResults = [Result]()

        // Iterate through every feature. This has to be abstracted out because the type of machine learning model can
        // change depending on what the user has selected.
        for index in 0..<predictions.count {

            // Grab the results at the specified index.
            let pred = predictions.features(at: index)

            // Create the Result struct and grab the validation score.
            let scores = pred.featureValue(for: "predictionProbability")!.dictionaryValue as! [String: Double]
            let result = Result(
                word: origin[index].replacingOccurrences(of: "*", with: ""),
                validation: pred.featureValue(for: "prediction")!.stringValue,
                confidence: scores["valid"] ?? 0
            )

            // Skip adding the result if it's an invalid sniglet.
            if result.validation != "valid" { continue }
            filteredResults.append(result)
        }

        // Return the filtered list.
        return filteredResults
    }
}
