//
//  SnigletValidations.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 15/11/21.
//

import Foundation

/// A class that contains all of the business logic needed to create and validate sniglets.
class Sniglet {

    /// A class reference to the machine learning model.
    public typealias Validator = SnigletValidator

    /// A shared instance of the Sniglet class.
    public static var shared: Sniglet { Sniglet() }

    private var model: Validator

    /// A data structure that contains a sniglet validation result with an ID, validation check, and a confidence rate.
    public struct Result: Hashable, Identifiable, Equatable {
        /// The unique identifier for this result.
        var id = UUID()

        /// The word for which the result pertains to.
        var word: String

        /// The validation status of this result.
        var validation: String

        /// The confidence rate of the result.
        var confidence: Double

        /// Returns an empty result.
        public static func empty() -> Result {
            Result(word: "empty", validation: "valid", confidence: 0.0)
        }

        /// Returns a nullish result.
        public static func null() -> Result {
            Result(word: "null", validation: "valid", confidence: 0.0)
        }

        /// Returns an errored result.
        public static func error() -> Result {
            Result(word: "error", validation: "valid", confidence: 0.0)
        }

        public static func ==(lhs: Result, rhs: Result) -> Bool {
            return lhs.word == rhs.word && lhs.validation == rhs.validation
        }
    }

    init() {
        model = try! SnigletValidator(configuration: .init())
    }

    /// Returns a list of results from the sniglet validator.
    /// - Parameter count: The number of words to create.
    public func getNewWords(count: Int = 1) -> Set<Result> {
        var generatedWords: [String] = []

        var minof = UserDefaults.standard.integer(forKey: "algoMinBound")
        if minof <= 0 {
            minof = 3
            UserDefaults.standard.set(3, forKey: "algoMinBound")
        }

        var maxof = UserDefaults.standard.integer(forKey: "algoMaxBound")
        if maxof <= 0 {
            maxof = 8
            UserDefaults.standard.set(8, forKey: "algoMaxBound")
        }

        var batchSize = UserDefaults.standard.integer(forKey: "algoBatchSize")
        if batchSize <= 0 {
            batchSize = 25
            UserDefaults.standard.set(25, forKey: "algoBatchSize")
        }

        var syllableStructs: SyllableShapes = .common()
        if let customStructs: SyllableShapes = SyllableShapes(
            rawValue: UserDefaults.standard.string(forKey: "customShapes") ?? "") {
            syllableStructs += customStructs
        }

        for _ in 0..<batchSize {
            var newWord = String.makeWord(limit: minof..<maxof, with: syllableStructs.randomElement() ?? "CV")
            if newWord.count < 8 {
                for _ in newWord.count..<8 {
                    newWord += "*"
                }
            }
            generatedWords.append(newWord)
        }

        var wordResults: Set<Result> = Set()

        do {
            let batchInput = generatedWords.map { word in word.asSnigletValidatorInput() }
            let batchResults = try model.predictions(inputs: batchInput).enumerated()
                .map { index, result in
                    Result(word: generatedWords[index].replacingOccurrences(of: "*", with: ""),
                           validation: result.Valid, confidence: result.ValidProbability["valid"] ?? 0)
                }
                .filter { result in result.validation == "valid" }

            while wordResults.count < count {
                wordResults.update(with: batchResults.randomElement() ?? .null())
            }
            return wordResults
        } catch {
            return Set(arrayLiteral: .error())
        }

    }
}
