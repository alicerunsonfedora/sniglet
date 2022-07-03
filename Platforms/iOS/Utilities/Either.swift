//
//  Either.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 3/7/22.
//

import Foundation

/// A struct that can contain two separate optional types.
/// This is commonly used to denote when a function may return two different types of data.
public struct Either<T, S> {

    /// The first of two options.
    public let left: T?

    /// The second of two options.
    public let right: S?

    public init(_ left: T?, or right: S?) {
        self.left = left
        self.right = right
    }
}
