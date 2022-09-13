//
//  WidgetBundle.swift
//  Sniglet Widget
//
//  Created by Marquis Kurt on 30/11/21.
//

import SwiftUI
import WidgetKit

@main struct SnigletWidgets: WidgetBundle {
    var body: some Widget {
        RandomSniglet()
        DailySavedSniglet()
    }
}
