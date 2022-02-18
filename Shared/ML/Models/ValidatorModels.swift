//
//  ValidatorModels.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 21/12/21.
//

import Foundation
import CoreML

/// An enumeration that represents the different kinds of validators users can choose from.
public enum ValidatorKind: String, CaseIterable, Equatable {

    /// The original validation model (Abysima).
    case Classic

    /// A validation model with fantasy words in mind.
    case Fantasy
}
