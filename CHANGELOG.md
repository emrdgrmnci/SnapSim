# Changelog

All notable changes to SnapSim will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Customizable keyboard shortcuts
- Multiple hide positions (corners)
- Support for multiple simulators simultaneously
- Animated hide/show transitions
- Configurable button appearance

## [1.1.0] - 2025-12-12

### Added
- **Auto-open when Simulator launches** - SnapSim can automatically activate when Xcode Simulator app opens
- **Launch at Login** - Option to automatically start SnapSim when you log in to your Mac
- Menu items to toggle both new features with visual checkmarks
- User preferences persistence for both features

### Fixed
- Fixed crash when using Launch at Login with empty login items list
- Improved LSSharedFileList API usage for better compatibility
- Fixed type conversion issues with deprecated CoreServices APIs

### Changed
- Enhanced menu with new options for auto-open and launch at login
- Improved error handling for login items management

## [1.0.0] - 2025-11-29

### Added
- Initial release
- Hide/show iOS Simulator with ⌘] keyboard shortcut
- Floating restore button when simulator is hidden
- Auto-center simulator when restored
- Menu bar integration
- Support for all simulator sizes (iPhone, iPad, Apple Watch)
- Accessibility API integration
- Clean, modern UI
- Works with resized simulator windows

### Features
- Menu bar icon with quick actions
- Check permissions from menu
- Bring simulator to front when restored
- Minimal memory footprint
- Native macOS app with zero dependencies

