//
//  MakeSnigletIntent.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 9/14/22.
//

import AppIntents
import SwiftUI

// FIXME: This doesn't compile under Xcode 14 RC with macOS Ventura. Maybe a beta update will fix this?
@available(iOS 16.0, *)
struct MakeSniglet: AppIntent {
    static var title: LocalizedStringResource = "Make Sniglet"
    static var description = IntentDescription("Generates a random sniglet.")

    func perform() async throws -> some ReturnsValue<String> {
        let result = await Sniglet.shared.getNewWords()
        return .result(value: result.first?.word ?? "")
    }
}
