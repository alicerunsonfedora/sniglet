# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2-16] - 08-12-2022
- Updates design for iOS 16 with new tables.
- Further adds customizable toolbars.

## [1.2-15] - 14-09-2022 (no macOS release)
- Removes "Tap to Copy" option and replaces it with a new toolbar item.
- Adds support for customizable toolbars for iPad (iOS 16).
- Adds new random sniglet Lock Screen widget (iOS 16).
- Improves sharing support on iOS 16 by allowing users to share images from the generator and the dictionary.
- Updates What's New screen.

## [2.0-14] - 14-08-2022 (also 1.2-14)
- Ports the new range slider for word boundaries to the iOS app (ABY-18).
- Updates sharing system in preparation for iOS 16.
- Introduces a new menu button that houses existing toolbar controls such as sharing and saving sniglets (ABY-17).

## [2.0-13]
- Introduces a brand-new redesign of the app on Mac with more information at a glance (ABY-11).

## [1.1.2] - 02-03-2022
- Resolves a bug where, in single sniglet mode, the sniglet always appears as "empty" (ABY-15).

## [1.1.1] - 26-02-2022

- Adds a toast notification to provide feedback when copying a word with "Tap to Copy" turned on (ABY-14).
- Resolves a bug where an empty range could occur when generating a long list of sniglets with bounds of the same size
  (ABY-12).

## [1.1.1-11] - 20-02-2022

- Adds a toast notification to provide feedback when copying a word with "Tap to Copy" turned on (ABY-14).
- Resolves a bug where an empty range could occur when generating a long list of sniglets with bounds of the same size
  (ABY-12).

## [1.1] - 19-02-2022

- Apple Watch Companion App: Generate sniglets on-the-fly and save them with the new app for Apple Watch.
- Live Listen: Listen to how sniglets are pronounced according to your device's settings. 
- Sniglet Dictionary: Save your favorite sniglets for later and define them in your personal dictionary. Share them with
  your friends and family as a neat little image or a text with a couple taps.
  - iCloud Sync: Your personal dictionary is stored in iCloud and syncs across all your devices seamlessly.
  - Daily Sniglet Widget: View sniglets from your dictionary right on your home screen with a new widget.

## [1.1-9] - 13-02-2022

- Fixes a styling issue with toast notifications to match the system's appearance.
- Updates the "What's New" dialog to discuss individual features, based on the target platform.
- Removes code referencing a non-existent in-app purchase upgrade.

## [1.1-8] - 06-02-2022

- Improves the share sheet experience on the Mac Catalyst target platform.
- Moves the share icon in the saved dictionary entry page to the rightmost option.
- Disables toggles for model selection (being held off until 1.2).
- Removes unnecessary Apple Watch complication files.
- Adds a warning to the "Generate N words" setting it goes over seven words per generation.
- Adds concurrency support to sniglet generation methods to improve load times.
- Improves the "What's New" dialog to not show the Apple Watch support point on Mac Catalyst targets.
- Refactors the Settings view into smaller subpages to make maintainability more feasible.
- Replaces saved alert with a non-intrusive toast notification.
- Introduces a new setting to change how saved sniglets are shared.

## [1.1-7] - 01-02-2022

- Apple Watch Companion App: Generate sniglets on-the-fly and save them with the new app for Apple Watch.
- Live Listen: Listen to how sniglets are pronounced according to your device's settings. 
- Context Menus: Right-click or long press on a sniglet in a generator list or your saved dictionary to perform common
  tasks quickly.
- Sniglet Dictionary: Save your favorite sniglets for later and define them in your personal dictionary.
  - iCloud Sync: Sync your saved sniglets across your devices in iCloud.
  - Image Share: Share your saved sniglets with your friends in a nice picture. 
- Daily Sniglet Widget: View sniglets from your dictionary right on your home screen with a new widget.
- License and Feedback: View the app's license and send feedback easily in Settings.

## [1.1-6] - 21-01-2022

This release fixes a styling problem in the About section on iPhone/small layouts (see ABY-8).

- Sniglet Dictionary: Save your favorite sniglets for later and define them in your personal dictionary.
  - iCloud Sync: Sync your saved sniglets across your devices in iCloud.
  - Image Share: Share your saved sniglets with your friends in a nice picture. 
- Daily Sniglet Widget: View sniglets from your dictionary right on your home screen with a new widget.
- License and Feedback: View the app's license and send feedback easily in Settings.

## [1.1-5] - 21-01-2022

- Sniglet Dictionary: Save your favorite sniglets for later and define them in your personal dictionary.
  - iCloud Sync: Sync your saved sniglets across your devices in iCloud.
  - Image Share: Share your saved sniglets with your friends in a nice picture. 
- Daily Sniglet Widget: View sniglets from your dictionary right on your home screen with a new widget.
- License and Feedback: View the app's license and send feedback easily in Settings.

## [1.1-4] - 11-01-2022

- Sniglet Dictionary: Save your favorite sniglets for later and define them in your personal dictionary.
    - iCloud Sync (new): Sync your saved sniglets across all your devices with iCloud.
- Daily Sniglet Widget: View sniglets from your dictionary right on your home screen with a new widget.

## [1.1-3] - 12-12-2021

- Sniglet Dictionary: Save your favorite sniglets for later and define them in your personal dictionary.
- Daily Sniglet Widget: View sniglets from your dictionary right on your home screen with a new widget.

## [1.0.1-2] - 11-12-2021

- Resolves a crash problem when setting the generation amount greater than four.
