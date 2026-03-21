# My App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.0+-blue.svg" alt="Dart Version">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
</p>



## 📱 Screenshots

<!-- Add your app screenshots here -->
<p align="center">
  <img src="screenshots/app_preview.png" alt="App Preview" width="300">
</p>

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Project Structure](#-project-structure)
- [Customization](#-customization)
- [Testing](#-testing)
- [Contributing](#-contributing)
- [Changelog](#-changelog)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

## 🚀 Features

This Flutter foundation project includes:

- 📱 **Clean Architecture** - Following ResoCoder's Clean Architecture pattern with proper separation of concerns
- 🎨 **Custom Design System** - Material 3 theming with customizable colors and consistent spacing
- 🌍 **Internationalization (i18n)** - Multi-language support with locale persistence
- � **Injectable DI** - Modern annotation-based dependency injection with Injectable/GetIt
- 🌐 **Environment Support** - Development, staging, and production environment configurations
- 📦 **State Management** - BLoC pattern for predictable state management
- 🚨 **Freezed Entities** - Immutable data classes with code generation
- 🧪 **Test Structure** - Comprehensive test setup mirroring the lib structure
- 🎯 **Error Handling** - Robust error handling with Either pattern
- 💾 **Local Storage** - SharedPreferences for persistent data storage
- 🔄 **FVM Support** - Flutter Version Management for consistent development environments

## 🏧 Architecture

This project follows **ResoCoder's Clean Architecture** principles with three distinct layers:

```
┌──────────────────────────┐
│     PRESENTATION LAYER   │  ← BLoC, Pages, Widgets
├──────────────────────────┤
│       DOMAIN LAYER       │  ← Entities, Use Cases, Repositories
├──────────────────────────┤
│        DATA LAYER        │  ← Models, Data Sources, Repositories
└──────────────────────────┘
```

- **Domain Layer**: Contains business logic, entities, and repository interfaces
- **Data Layer**: Handles data sources, models, and repository implementations
- **Presentation Layer**: Contains UI components, BLoCs, and pages

## 📁 Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── design_system/            # Design system components
│   │   ├── theme/               # App theming (colors, Material 3)
│   │   ├── typography/          # Text styles and font weights
│   │   ├── spacing/             # Spacing constants and layout
│   │   └── components/          # Reusable UI components
│   ├── error/                   # Error handling (failures, exceptions)
│   ├── network/                 # Network utilities and connectivity
│   ├── platform/               # Platform-specific utilities
│   └── usecases/               # Base use case interface
├── features/                    # Feature modules (Clean Architecture)
│   ├── i18n/                    # Internationalization feature
│   │   ├── domain/             # Business logic (entities, repositories, use cases)
│   │   ├── data/               # Data layer (models, data sources, repository impl)
│   │   └── presentation/       # UI layer (BLoC, pages, widgets)
│   └── app_info/               # App information demo feature
│       ├── domain/
│       ├── data/
│       └── presentation/
├── injection.dart              # Injectable configuration with environments
├── injectable_module.dart      # External dependencies configuration
├── bootstrap.dart              # Environment-specific app initialization
├── main.dart                   # Default entry point (development)
├── main_development.dart       # Development environment entry
├── main_staging.dart           # Staging environment entry
├── main_production.dart        # Production environment entry
└── app.dart                    # App widget configuration

test/                           # Tests mirroring lib structure
├── core/
├── features/
└── widget_test.dart
```

## Getting Started

### Prerequisites

- [FVM (Flutter Version Management)](https://fvm.app/) - Recommended for Flutter version management
- Flutter SDK (>=3.0.0) - Will be automatically configured via FVM
- Dart SDK (>=3.0.0)

## 🚀 Getting Started

### Prerequisites

- [FVM (Flutter Version Management)](https://fvm.app/) - Recommended for Flutter version management
- Flutter SDK (>=3.0.0) - Will be automatically configured via FVM
- Dart SDK (>=3.0.0)
- [Git](https://git-scm.com/)
- IDE: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone or generate the project:**
   ```bash
   # If using Mason CLI
   mason make flutter_foundation

   # Or clone if from repository
   git clone <repository-url>
   cd my_app
   ```

2. **FVM will be automatically configured** during generation via post-hooks

3. **Get dependencies:**
   ```bash
   fvm flutter pub get
   ```

4. **Generate code for Injectable and Freezed:**
   ```bash
   # Generate Injectable and Freezed code
   dart run build_runner build --delete-conflicting-outputs

   # For development with file watching
   dart run build_runner watch --delete-conflicting-outputs
   ```

### Running the App

The project supports different environments for development, staging, and production:

```bash
# Development environment (default)
fvm flutter run --target lib/main_development.dart --flavor development

# Staging environment
fvm flutter run --target lib/main_staging.dart --flavor staging

# Production environment
fvm flutter run --target lib/main_production.dart --flavor production

# Or use the default main.dart (defaults to development)
fvm flutter run

# Build for release
fvm flutter build apk --release --target lib/main_production.dart
```

### Setting Up Flavors for iOS and macOS

If you added iOS or macOS platforms to your project, you should configure build schemes and flavors to match your development environments.

**📖 Reference:** [Flutter Flavors Setup Guide](https://docs.flutter.dev/deployment/flavors-ios)

**Quick Steps:**
1. **Create Xcode schemes** for each flavor (Development, Staging, Production)
2. **Configure build variables** and provisioning profiles per scheme
3. **Link Flutter targets** to Xcode schemes in build settings
4. **Use schemes** when building: `xcodebuild -scheme Development build`

This allows seamless environment switching on iOS and macOS without code changes.

### Running Tests

```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Run specific test file
fvm flutter test test/core/error/failures_test.dart
```

### Test Structure
The test directory mirrors the lib structure:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete flows

### Adding Tests
For each new feature, create corresponding tests:
```bash
# Example: Adding tests for new feature
touch test/features/your_feature/domain/usecases/your_usecase_test.dart
touch test/features/your_feature/presentation/bloc/your_bloc_test.dart
```

## 🎨 Customization

This foundation project is designed to be highly customizable:

### 🌈 Colors
The primary and secondary colors were set during generation:
- **Primary:** 2196F3
- **Secondary:** FF9800

To modify colors, edit `lib/core/design_system/theme/color_palette.dart`.

### 🔤 Typography
The app uses **Poppins** as the primary font family.

To use custom fonts:
1. Add your font files to `assets/fonts/` directory with these exact naming conventions:
   - `Poppins-Regular.ttf` (font weight 400)
   - `Poppins-SemiBold.ttf` (font weight 600)
   - `Poppins-Medium.ttf` (font weight 500)
   - `Poppins-Bold.ttf` (font weight 700)

2. The `pubspec.yaml` is already configured to load these fonts from `assets/fonts/`

3. Font references are configured in `lib/core/design_system/theme/app_theme.dart`

Note: Font files must be provided by you. The brick only generates the configuration to use them.

### 🌍 Languages
This project supports **EN** as the base language with i18n framework ready for additional languages.

To add more languages:
1. Update `lib/features/i18n/data/models/locale_model.dart`
2. Add the locale to `supportedLocales` in `lib/app.dart`
3. Create translation files for the new language

### 📦 Adding Features
Each new feature should follow the Clean Architecture pattern:

```bash
# Create feature structure
mkdir -p lib/features/your_feature/{domain,data,presentation}
mkdir -p lib/features/your_feature/domain/{entities,repositories,usecases}
mkdir -p lib/features/your_feature/data/{models,datasources,repositories}
mkdir -p lib/features/your_feature/presentation/{bloc,pages,widgets}
```

### 💉 Dependency Injection with Injectable

This project uses **Injectable** for modern annotation-based dependency injection:

#### Adding New Dependencies

1. **Service/Repository**:
   ```dart
   @LazySingleton()
   class MyRepository implements MyRepositoryInterface {
     // implementation
   }
   ```

2. **Use Cases**:
   ```dart
   @LazySingleton()
   class MyUseCase {
     final MyRepository repository;
     const MyUseCase(this.repository);
   }
   ```

3. **BLoCs**:
   ```dart
   @injectable
   class MyBloc extends Bloc<MyEvent, MyState> {
     final MyUseCase useCase;
     MyBloc(this.useCase) : super(MyInitial());
   }
   ```

4. **External Dependencies** (add to `injectable_module.dart`):
   ```dart
   @singleton
   @preResolve
   Future<MyExternalService> get myService => MyExternalService.init();
   ```

#### Environment-Specific Configuration

Configure different values for each environment in `injectable_module.dart`:
```dart
@Singleton(env: [DevEnv.kName])
@Named('API_URL')
String get devApiUrl => 'https://api.dev.example.com';

@Singleton(env: [ProdEnv.kName])
@Named('API_URL')
String get prodApiUrl => 'https://api.example.com';
```

#### Using Dependencies
```dart
// Get instance
final myBloc = getIt<MyBloc>();

// Get named instance
final apiUrl = getIt<String>(instanceName: 'API_URL');

// In widgets (with get_it_mixin)
class MyWidget extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    final bloc = watchOnly<MyBloc, MyState>((bloc) => bloc.state);
    return Container(); // Your widget
  }
}
```

**Remember to run code generation after adding new @injectable classes:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

##  Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the project
2. **Create** a feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make** your changes following the architecture patterns
4. **Add tests** for new functionality
5. **Ensure** all tests pass:
   ```bash
   fvm flutter test
   fvm flutter analyze
   ```
6. **Commit** your changes:
   ```bash
   git commit -m 'Add amazing feature'
   ```
7. **Push** to the branch:
   ```bash
   git push origin feature/amazing-feature
   ```
8. **Submit** a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use the provided linting rules (`analysis_options.yaml`)
- Maintain the Clean Architecture pattern
- Write tests for new features

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[ResoCoder](https://resocoder.com/)** - For the Clean Architecture pattern and tutorials
- **[Felix Angelov](https://github.com/felangel)** - For the BLoC library and patterns
- **[Material Design Team](https://material.io/)** - For the Material 3 design system
- **[Mason Team](https://github.com/felangel/mason)** - For the amazing code generation tool
- **[FVM Team](https://fvm.app/)** - For Flutter Version Management

---

<p align="center">
  Made with ❤️ using <a href="https://flutter.dev">Flutter</a> and <a href="https://github.com/felangel/mason">Mason</a>
</p>
