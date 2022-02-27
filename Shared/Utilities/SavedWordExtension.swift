//
//  SavedWordExtension.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 27/2/22.
//

import Foundation
import CoreData

extension SavedWord {

    /// Returns a multi-line string suitable for sharing services such as ``NSShareServicePicker``.
    ///
    /// An example is seen below:
    ///
    ///     Check out this sniglet I generated:
    ///     word
    ///     A collection of letters that convey a meaning
    ///
    ///     Confidence: 69%
    ///     From Give Me A Sniglet
    ///
    func shareableText() -> String {
        """
        Check out this sniglet I generated:
        \(self.word ?? "")
        \(self.note ?? "")

        Confidence: \(self.confidence.asPercentage())%
        From Give Me A Sniglet
        """
    }

}
