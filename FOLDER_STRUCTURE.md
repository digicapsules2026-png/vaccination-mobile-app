# Folder Structure Documentation

Complete overview of the Flutter app architecture and folder organization.

## 📁 Root Structure

```
vaccination-mobile-app/
├── android/                 # Android native code
├── ios/                    # iOS native code
├── lib/                    # Dart source code
├── test/                   # Unit & widget tests
├── integration_test/       # Integration tests
├── assets/                # Static assets
├── pubspec.yaml           # Dependencies
└── README.md              # Documentation
```

## 📂 lib/ Directory

### Core Module (`lib/core/`)

```
lib/core/
├── config/
│   └── app_config.dart          # Environment & constants
├── theme/
│   └── app_theme.dart           # App theme & text styles
├── router/
│   └── app_router.dart          # Navigation & routes
├── network/
│   ├── api_client.dart          # Dio HTTP client
│   └── api_response.dart        # Response wrapper (freezed)
├── services/
│   ├── auth_service.dart        # Token management
│   └── notification_service.dart # Push notifications
└── utils/
    ├── validators.dart          # Form validators
    ├── formatters.dart          # Date/number formatters
    └── constants.dart           # App constants
```

### Features Module (`lib/features/`)

Each feature follows Clean Architecture:

```
lib/features/<feature_name>/
├── data/
│   ├── models/              # Data models (freezed)
│   ├── repositories/        # Repository implementations
│   └── datasources/         # API & local data sources
├── domain/
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/          # Business logic
└── presentation/
    ├── pages/             # Full-screen pages
    ├── widgets/           # Reusable widgets
    ├── providers/         # Riverpod providers
    └── state/            # State classes
```

## 🎯 Feature Modules

### 1. Authentication (`lib/features/auth/`)

```
auth/
├── data/
│   ├── models/
│   │   └── user_model.dart          # User & token models
│   └── repositories/
│       └── auth_repository.dart     # Auth API calls
└── presentation/
    └── pages/
        ├── login_page.dart          # Login screen
        ├── register_page.dart       # Registration screen
        └── splash_page.dart         # Splash screen
```

### 2. Home (`lib/features/home/`)

```
home/
└── presentation/
    ├── pages/
    │   └── home_page.dart           # Dashboard
    └── widgets/
        ├── stat_card.dart           # Statistics cards
        └── quick_action_tile.dart   # Action buttons
```

### 3. Children (`lib/features/children/`)

```
children/
├── data/
│   ├── models/
│   │   └── child_model.dart         # Child profile model
│   └── repositories/
│       └── children_repository.dart # Children API
└── presentation/
    ├── pages/
    │   ├── children_list_page.dart  # List of children
    │   ├── child_detail_page.dart   # Child details
    │   ├── add_child_page.dart      # Add new child
    │   └── edit_child_page.dart     # Edit child
    └── widgets/
        ├── child_card.dart          # Child card widget
        └── child_form.dart          # Reusable form
```

### 4. Vaccinations (`lib/features/vaccinations/`)

```
vaccinations/
├── data/
│   ├── models/
│   │   ├── vaccination_model.dart    # Vaccination record
│   │   └── vaccine_model.dart        # Vaccine master
│   └── repositories/
│       └── vaccination_repository.dart
└── presentation/
    ├── pages/
    │   ├── vaccination_list_page.dart # History list
    │   ├── vaccination_detail_page.dart
    │   ├── add_vaccination_page.dart
    │   └── schedule_page.dart         # Upcoming vaccines
    └── widgets/
        ├── vaccination_card.dart
        ├── vaccine_timeline.dart      # Timeline widget
        └── schedule_item.dart
```

### 5. Scanner (`lib/features/scanner/`)

```
scanner/
└── presentation/
    ├── pages/
    │   ├── qr_scanner_page.dart      # QR code scanner
    │   └── vial_scanner_page.dart    # Barcode scanner
    └── widgets/
        ├── scanner_overlay.dart       # Scan overlay UI
        └── scan_result.dart           # Result display
```

### 6. Documents (`lib/features/documents/`)

```
documents/
├── data/
│   ├── models/
│   │   └── document_model.dart
│   └── repositories/
│       └── document_repository.dart
└── presentation/
    ├── pages/
    │   ├── documents_page.dart        # Documents list
    │   ├── document_viewer_page.dart  # View PDF/Image
    │   └── upload_document_page.dart  # Upload flow
    └── widgets/
        └── document_card.dart
```

### 7. ABHA Integration (`lib/features/abha/`)

```
abha/
├── data/
│   ├── models/
│   │   └── abha_model.dart
│   └── repositories/
│       └── abha_repository.dart
└── presentation/
    ├── pages/
    │   ├── abha_link_page.dart        # Link ABHA
    │   └── abha_consent_page.dart     # Consent management
    └── widgets/
        └── abha_card.dart
```

## 🎨 Assets (`assets/`)

```
assets/
├── images/
│   ├── logo.png
│   ├── splash.png
│   └── placeholder.png
├── icons/
│   ├── app_icon.png
│   └── app_icon_foreground.png
├── fonts/
│   ├── Inter-Regular.ttf
│   ├── Inter-Medium.ttf
│   ├── Inter-SemiBold.ttf
│   └── Inter-Bold.ttf
└── animations/
    └── loading.json            # Lottie animations
```

## 🧪 Tests (`test/`)

```
test/
├── unit/
│   ├── models/
│   ├── repositories/
│   └── usecases/
├── widget/
│   └── widgets/
└── fixtures/
    └── mock_data.dart          # Test data
```

## 📱 Platform-Specific

### Android (`android/`)

```
android/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── AndroidManifest.xml  # Permissions
│   │       ├── kotlin/              # Native code
│   │       └── res/                 # Resources
│   └── build.gradle                 # Build config
└── gradle.properties
```

### iOS (`ios/`)

```
ios/
├── Runner/
│   ├── Info.plist                   # App config
│   ├── Assets.xcassets/             # App icons
│   └── AppDelegate.swift            # Native code
└── Podfile                          # CocoaPods deps
```

## 🔧 Configuration Files

- `pubspec.yaml` - Flutter dependencies & assets
- `analysis_options.yaml` - Linting rules
- `.gitignore` - Git ignore patterns
- `README.md` - Main documentation
- `QUICKSTART.md` - Quick start guide
- `FOLDER_STRUCTURE.md` - This file

## 📝 Code Generation Files

Generated files (ignored in git):
- `*.g.dart` - JSON serialization
- `*.freezed.dart` - Freezed immutable classes

Generate with:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎯 Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE` or `kConstantName`
- **Private**: `_privateVariable`

## 📦 Feature Module Template

When creating a new feature:

```
lib/features/new_feature/
├── data/
│   ├── models/
│   │   └── new_feature_model.dart
│   └── repositories/
│       └── new_feature_repository.dart
└── presentation/
    ├── pages/
    │   └── new_feature_page.dart
    ├── widgets/
    │   └── custom_widget.dart
    └── providers/
        └── new_feature_provider.dart
```

## 🚀 Best Practices

1. **Feature Independence**: Each feature should be self-contained
2. **Clean Architecture**: Separate data, domain, and presentation
3. **Code Generation**: Use freezed for models, riverpod_generator for providers
4. **Testing**: Write tests for business logic and critical UI
5. **Documentation**: Document complex logic and public APIs
















