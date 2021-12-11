//
//  DoubleExtension.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 16/11/21.
//

import Foundation

extension Double {
    func asPercentage() -> Int {
        var new = self
        if new < 100 { new *= 100 }
        return Int(new.rounded())
    }
}

extension Set where Element: Hashable {
    /// Returns the set as an array.
    func asArray() -> [Element] {
        self.map { c in c }
    }
}
