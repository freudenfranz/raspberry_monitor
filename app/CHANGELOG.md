# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup with Clean Architecture
- Custom Design System with Material 3 theming
- Internationalization (i18n) feature with locale persistence
- App Info demo feature showcasing Clean Architecture
- Comprehensive dependency injection setup with GetIt
- BLoC state management throughout the application
- Error handling with Either pattern and custom failures
- FVM (Flutter Version Management) integration
- Complete test structure mirroring lib directory
- Custom UI components (buttons, text fields, loading, error widgets)
- Comprehensive documentation and README

### Technical Details
- Flutter SDK: >=3.0.0
- Dart SDK: >=3.0.0
- Architecture: ResoCoder's Clean Architecture pattern
- State Management: flutter_bloc ^8.1.3
- Dependency Injection: get_it ^7.6.4
- Functional Programming: dartz ^0.10.1
- Local Storage: shared_preferences ^2.2.2
- Connectivity: connectivity_plus ^5.0.1, internet_connection_checker ^1.0.0+1
- App Info: package_info_plus ^4.2.0
- Testing: mockito ^5.4.2, bloc_test ^9.1.4

## [0.1.0] - --

### Added
- Initial release of My App foundation project
- Complete Clean Architecture implementation
- Material 3 design system with customizable theming
- Internationalization framework with EN base language
- Production-ready project structure
- Comprehensive testing setup
- FVM integration for Flutter version management

### Features
- 📱 Clean Architecture following ResoCoder patterns
- 🎨 Custom Design System with Material 3
- 🌍 Internationalization with locale persistence
- 🔧 Dependency Injection with GetIt
- 📦 BLoC State Management
- 🧪 Comprehensive Test Structure
- 🎯 Error Handling with Either pattern
- 💾 Local Storage with SharedPreferences
- 🔄 FVM Support for version management

---

## How to Update This Changelog

When making changes to the project:

1. Add new changes to the `[Unreleased]` section
2. Use these categories:
   - `Added` for new features
   - `Changed` for changes in existing functionality
   - `Deprecated` for soon-to-be removed features
   - `Removed` for now removed features
   - `Fixed` for any bug fixes
   - `Security` for vulnerability fixes

3. When releasing a new version:
   - Change `[Unreleased]` to the version number and date
   - Create a new `[Unreleased]` section at the top

Example:
```markdown
## [Unreleased]

### Added
- New awesome feature

### Fixed
- Bug in existing feature

## [1.1.0] - 2026-03-15

### Added
- Previous unreleased features
```
