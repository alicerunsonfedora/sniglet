//
//  AppGroup.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 12/12/21.
//

import Foundation

public enum AppGroup: String {
  case sniglets = "group.net.marquiskurt.sniglets"

  public var containerURL: URL {
    switch self {
    case .sniglets:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
