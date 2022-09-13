//
//  URL.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 8/5/22.
//

import Foundation

extension URL {
    func queryParameters() -> [String: String?]? {
        guard let urlComps = URLComponents(string: absoluteString) else { return nil }
        var params = [String: String?]()
        urlComps.queryItems?.forEach { item in
            params[item.name] = item.value
        }
        return params
    }
}
