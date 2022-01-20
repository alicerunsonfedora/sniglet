//
//  AppVersions.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 20/1/22.
//

import Foundation

/// Returns the version and build number of the app in the format "Version (Build)".
/// - Note: If `CFBundleShortVersionString` and/or `CFBundloeVersion` are not found, their values will be replaced with `0`.
func getAppVersion() -> String {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    return "\(appVersion) (\(appBuild))"
}
