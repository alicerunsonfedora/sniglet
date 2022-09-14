//
//  WidgetBundle.swift
//  Sniglet Widget
//
//  Created by Marquis Kurt on 30/11/21.
//

import SwiftUI
import WidgetKit

@main
struct SnigletWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        RandomSniglet()
        DailySavedSniglet()
        supportedWidgetsForFuture()
    }

    func supportedWidgetsForFuture() -> some Widget {
        if #available(iOS 16.0, *) {
            return WidgetBundleBuilder.buildBlock(RandomSnigletAccessory())
        } else {
            return WidgetBundleBuilder.buildBlock()
        }
    }
}
