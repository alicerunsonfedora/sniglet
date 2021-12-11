//
//  SyllableShapes.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 22/11/21.
//

import Foundation

typealias SyllableShapes = [String]

extension SyllableShapes: RawRepresentable {

    static func common() -> SyllableShapes {
        ["CV", "CVC", "CVVC", "CCV"]
    }


    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(SyllableShapes.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
