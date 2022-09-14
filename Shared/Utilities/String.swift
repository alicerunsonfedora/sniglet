//
//  String.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 21/11/21.
//

import Foundation
import AVFoundation

extension String {
    /// A string of vowels.
    public static let vowels = "aeiouy"

    /// A string of consonants.
    public static let consonants = "bcdfghjklmnprqstvwxz"

    /// Whether the string consists of only syllable markers (C, V).
    public var isMarker: Bool {
        var succeeded = true
        self.forEach { char in
            if char != "C" && char != "V" { succeeded = false }
        }
        return succeeded
    }


    /// Returns a random sequence of letters shaped around a syllabic structure.
    /// - Parameter wordRange: The range which describes how long the word can be.
    /// - Parameter syllabicStruct: A string containing consonant and vowel markers that describe the shape of the word.
    public static func makeWord(limit wordRange: Range<Int> = 3..<12, with syllabicStruct: String = "CV") -> String {
        var currentSyllableIdx = 0
        var result = ""
        for _ in 0...Int.random(in: wordRange) {
            if syllabicStruct[currentSyllableIdx] == "V" {
                result.append(String.vowels.randomElement() ?? "e")
            } else {
                result.append(String.consonants.randomElement() ?? "t")
            }
            currentSyllableIdx += 1
            if currentSyllableIdx >= syllabicStruct.count {
                currentSyllableIdx = 0
            }
        }
        return result
    }

    /// Returns a randomly-generated word from a range and a specified syllabic structure.
    public static func makeWord(min: Int = 3, max: Int = 12, with syllabicStruct: String = "CV") -> String {
        String.makeWord(limit: min..<max, with: syllabicStruct)
    }

    /// Returns a list of characters as strings.
    func splitCharacters() -> [String] {
        self.map { char in String(char) }
    }

    /// Returns a string that replaces vowel characters with "V" and consonant characters with "C".
    ///
    /// This is commonly used to describe a syllable's shape.
    func toSyllableMarker() -> String {
        self.lowercased()
            .map { character in String.vowels.contains(character) ? "V" : "C" }
            .enumerated()
            .filter { element in element.offset < 8 }
            .map { _, element in element }
            .joined(separator: "")
    }

    /// Returns the current string as an input for the Sniglet validation model.
    /// - SeeAlso: ``Sniglet.Validator``
    func asModelInput() -> ClassicInput {
        let wordSplit = self.splitCharacters()
        return ClassicInput(
            char01: wordSplit[0], char02: wordSplit[1], char03: wordSplit[2], char04: wordSplit[3],
            char05: wordSplit[4], char06: wordSplit[5], char07: wordSplit[6], char08: wordSplit[7])
    }

    /// Speak the current string using an `AVSpeechSynthesizer`.
    func speak() {
        let utterance = AVSpeechUtterance(string: self)
        utterance.voice = .speechVoices().first
        AVSpeechSynthesizer.shared.speak(utterance)
    }
}

extension StringProtocol {
    /// Returns a character from the defined offset.
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
