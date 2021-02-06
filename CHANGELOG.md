# Change Log

All notable changes to the Social Buddy Bot app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project (mostly) adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.2] - 2021-02-06

- Renamed project to `Social Buddy Bot` and package to `com.socialbuddybot.app`
- Switched flutter to stable channel
- Updated flutter to `1.22.6`
- Updated svg package to `0.18.0`

## [2.0.1] - 2020-07-15

### Fixed

- Fixed bug where action command captions would not disappear after executing.

## [2.0.0] - 2020-07-14

### Added

- Implemented multiple event types (announcement, action, reminder and important reminder).
- Loading indicator for delay/confirmation periods.

## [0.0.15] - 2020-07-14

MVP done.

### Added

- Pre-commit script for CI.
- Flutter version restriction.

### Changed

- Set line length set to 80 and added corresponding analyzer rule.
- Removed build number in favor of using CI build numbers.

## [0.0.14+18] - 2020-05-31

### Added

- Confirmation after handling event.

### Changed

- Improved event screen layout method.

## [0.0.13+17] - 2020-05-27

### Changed

- Updated eyes animations.

### Fixed

- Drawer buttons now function again.

## [0.0.12+16] - 2020-05-26

### Changed

- Changed event icons to SVG.
- Changed layout and UI colors.

### Fixed

- Disable event buttons, icon and captions when no faces are present.
- Replay animation when pressing the same event button twice.

## [0.0.11+15] - 2020-05-23

### Added

- Rive animations.
- TTS subtitles.

### Changed

- Restructured UI.
- Remove `CachedStream` and related classes in favor of RxDart equivalent.

## [0.0.10+14] - 2020-04-20

### Added

- iOS build compatibility.

### Changed

- Replace `flutter_tts` with `flutter_tts_improved` for better future compatibility.

## [0.0.9+13] - 2020-04-16

### Fixed

- Fix Android build issues and crash at launch on some devices.

## [0.0.9+12] - 2020-04-16

### Added

- Basic text to speech functionality.

## [0.0.8+11] - 2020-04-13

### Fixed

- Fix Android build issues and crash at launch on some devices.

## [0.0.8+10] - 2020-04-13

### Addded

- Add assumed face detection trigger with timeout.
- Hook up face detection to UI.

### Changed

- Increased Flutter version constraint to the latest beta version: 1.17.0
- Improved logging.

## [0.0.7+9] - 2020-04-03

### Addded

- Face detection backend and simple camera view.

### Changed

- Improved the debug drawer UI.

### Fixed

- Fix bug where the calendar could not be deselected.

## [0.0.6+8] - 2020-03-25

### Fixed

- Fix bug where no calendar could be selected at first startup.

## [0.0.5+7] - 2020-03-24

### Changed

- Upgraded Flutter target version.

## [0.0.5+6] - 2020-03-24

### Changed

- BREAKING: Calendar event decisions are now saved in the event's description.

### Fixed

- Fix a bug where recurring events would not be shown to the user after checking off or postponing.

## [0.0.4+5] - 2020-03-16

### Changed

- Expand event pickup frame to 12 hours before and 15 minutes after current time.

### Fixed

- Fixed null calendars in release mode by adding proguard rules for device_calendar plugin.

## [0.0.3+4] - 2020-03-10

### Added

- Event handling snackbar confirmation.

### Fixed

- Fixed bug where event list would not update if an event was checked off.

## [0.0.2+3] - 2020-03-10

### Added

- Remind and postpone buttons.
- Debug drawer.

## [0.0.1+2] - 2020-03-07

### Added

- Android app signing.

## [0.0.1+1] - 2020-03-02

Initial project creation.

### Added

- Calendar API.
