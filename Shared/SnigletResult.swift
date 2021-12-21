//
//  SnigletResult.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 11/12/21.
//

import Foundation

/// A data structure that contains a sniglet validation result with an ID, validation check, and a confidence rate.
struct SnigletResult: Hashable, Identifiable, Equatable {
    /// The unique identifier for this result.
    var id = UUID()

    /// The word for which the result pertains to.
    var word: String

    /// The validation status of this result.
    var validation: String

    /// The confidence rate of the result.
    var confidence: Double

    /// Returns an empty result.
    public static func empty() -> SnigletResult {
        SnigletResult(word: "empty", validation: "valid", confidence: 0.0)
    }

    /// Returns a nullish result.
    public static func null() -> SnigletResult {
        SnigletResult(word: "null", validation: "valid", confidence: 0.0)
    }

    /// Returns an errored result.
    public static func error() -> SnigletResult {
        SnigletResult(word: "error", validation: "valid", confidence: 0.0)
    }

    /// Determines whether a result is equal to another.
    public static func ==(lhs: SnigletResult, rhs: SnigletResult) -> Bool {
        return lhs.word == rhs.word && lhs.validation == rhs.validation
    }
}
