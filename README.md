# Give Me A Sniglet!

Give Me a Sniglet is a random word-like generator with an on-device machine learning model that validates whether the
word is likely to be valid. Generate a set of words and view various confidence score, and copy them to your clipboard
with a single tap. Customize the algorithm by changing the size of the words and syllable shapes.

![App screenshots](.readme/screenshot.png)

<p align="center">
    <a href="https://apple.co/336C4oX">
        <img src="/.readme/appstore.svg" height="64" alt="Get on the App Store" />
    </a>
</p>

---

This project was originally a part of Codename Abysima as an attempt to generate a language using machine learning. Now,
this project will host updates to the Give Me A Sniglet app.

More information on the original project can be found at https://github.com/alicerunsonfedora/abysima.

## Features

- Generate as many sniglets as you like and share them easily
- Customize the generation algorithm by adjusting the word length and syllabic shapes
- View random sniglets on your home screen with the Random Sniglet Widget
    - 🧪 Select from different trained models for validation
- 🧪 Save your favorite sniglets into a personal dictionary synced with iCloud
    - 🧪 Assign a definition to your saved sniglets for future reference
    - 🧪 View a different entry every day with the Daily Saved Sniglet Widget
- 🧪 Generate sniglets on-the-go with support for Apple Watch

> *Features marked with 🧪 are in a pre-release state, usually in a TestFlight build.

## Build from source

**Required Toolchain**

- Xcode 13 or later
- macOS 12.0 Monterey or later

Clone the repository using `git clone`, and then open the Xcode project. To run for iOS, change the run target from
"My Mac" to either an iOS simulator device or "Any iOS Device". The same applies for macOS.

## Found a bug?

Please report an issue on YouTrack at https://youtrack.marquiskurt.net/youtrack/newIssue?project=ABY.

## License

This software is licensed under the Mozilla Public License, v2. More information on your rights can be found in the
LICENSE file.

## Privacy Policy

Please refer to https://marquiskurt.net/app-privacy.html for this app's privacy policy.
