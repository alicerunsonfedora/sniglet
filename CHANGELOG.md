# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
