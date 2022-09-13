//
//  SnigletShareable.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 3/7/22.
//

import Foundation
import UIKit
import SwiftUI
import Bunker

/// A protocol that indicates a view has the capability of sharing a sniglet.
protocol SnigletShareable {

    /// Whether to show the share sheet.
    var showShareSheet: Bool { get set }

    /// Fetches content to be sent to the share sheet.
    func getShareableContent() -> Either<UIImage, String>

    /// Creates a list of shared activities from shared content.
    func createShareActivities(from data: Either<UIImage, String>) -> [Any]

}

extension SnigletShareable {
    func createShareActivities(from data: Either<UIImage, String>) -> [Any] {
        data.getEither { image in
            [image]
        } defaultCase: { text in
            [text]
        }
    }
}
