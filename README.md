# Vaccination Locker - Mobile App

Production-ready Flutter mobile application for Baby Immunization & Vaccination Records Management System (Android & iOS).

## 🚀 Overview

A cross-platform mobile app built with Flutter that provides parents with a complete solution to manage their children's vaccination records, schedules, and health documents on-the-go.

## ✨ Features

### Core Features
- **Parent Registration & Login**: Secure JWT-based authentication
- **Child Profile Management**: Add and manage multiple child profiles
- **QR Code Generation**: Unique QR code per child for quick access
- **Vaccination Records**: Complete vaccination history timeline
- **Vaccine Vial Scanning**: Barcode/QR scanning to auto-fill vaccine details
- **Document Management**: Upload vaccination cards, prescriptions (PDF/Images)
- **ABHA Integration**: Link Ayushman Bharat Health Account
- **Vaccination Schedule**: View upcoming vaccines with reminders
- **Push Notifications**: Vaccination reminders and alerts
- **Offline Access**: Read-only offline access to records
- **PDF Reports**: Download and share immunization reports

### Technical Features
- **Flutter 3.x**: Latest stable Flutter SDK
- **Riverpod**: Modern state management
- **Clean Architecture**: Feature-first, layered architecture
- **Dio**: HTTP client with interceptors
- **Secure Storage**: Encrypted token storage
- **Camera Integration**: QR/Barcode scanning
- **Local Notifications**: Scheduled reminders
- **Material Design 3**: Modern UI/UX

## 📋 Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode
- VS Code (recommended)

### Platform-Specific Requirements

**Android:**
- Android SDK 21+ (Android 5.0)
- Gradle 7.0+

**iOS:**
- iOS 11.0+
- Xcode 14+
- CocoaPods

## 🛠️ Installation & Setup

### 1. Install Flutter

Follow the official guide: https://docs.flutter.dev/get-started/install

### 2. Clone Repository

```bash
git clone <repository-url>
cd vaccination-mobile-app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Generate Code

```bash
# Run code generation for freezed, json_serializable, riverpod
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Configuration

Update API endpoint in `lib/core/config/app_config.dart`:

```dart
// For Android Emulator
apiBaseUrl = 'http://10.0.2.2:8000';

// For iOS Simulator
apiBaseUrl = 'http://localhost:8000';

// For Physical Device (use your local IP)
apiBaseUrl = 'http://192.168.1.100:8000';

// For Production
apiBaseUrl = 'https://api.vaccinationlocker.com';
```

### 6. Run the App

```bash
# Check connected devices
flutter devices

# Run on Android
flutter run

# Run on iOS
flutter run

# Run on specific device
flutter run -d <device-id>
```

## 📁 Project Structure

```
vaccination-mobile-app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── core/                        # Core utilities
│   │   ├── config/
│   │   │   └── app_config.dart      # Environment config
│   │   ├── theme/
│   │   │   └── app_theme.dart       # App theme & styles
│   │   ├── router/
│   │   │   └── app_router.dart      # Navigation routes
│   │   ├── network/
│   │   │   ├── api_client.dart      # Dio client
│   │   │   └── api_response.dart    # Response wrapper
│   │   └── services/
│   │       ├── auth_service.dart    # Token management
│   │       └── notification_service.dart
│   └── features/                    # Feature modules
│       ├── auth/                    # Authentication
│       │   ├── data/
│       │   │   ├── models/
│       │   │   └── repositories/
│       │   └── presentation/
│       │       └── pages/
│       │           ├── login_page.dart
│       │           └── register_page.dart
│       ├── home/                    # Home dashboard
│       │   └── presentation/pages/
│       ├── children/                # Child profiles
│       │   ├── data/models/
│       │   └── presentation/pages/
│       │       ├── children_list_page.dart
│       │       ├── child_detail_page.dart
│       │       └── add_child_page.dart
│       ├── vaccinations/            # Vaccination records
│       │   └── presentation/pages/
│       └── scanner/                 # QR/Barcode scanning
│           └── presentation/pages/
│               ├── qr_scanner_page.dart
│               └── vial_scanner_page.dart
├── android/                         # Android native code
├── ios/                            # iOS native code
├── assets/                         # Static assets
│   ├── images/
│   ├── icons/
│   └── fonts/
├── pubspec.yaml                    # Dependencies
└── README.md
```

## 🎨 Architecture

### Clean Architecture Layers

1. **Presentation Layer**
   - UI (Pages/Widgets)
   - State Management (Riverpod)
   - View Models

2. **Domain Layer**
   - Business Logic
   - Use Cases
   - Entities

3. **Data Layer**
   - Repositories
   - Data Sources (API, Local DB)
   - Models

### Feature-First Structure

Each feature is self-contained with its own:
- Data models
- Repositories
- Business logic
- UI components

## 🔐 Authentication Flow

1. User opens app
2. Check if token exists in secure storage
3. If yes, validate token and navigate to home
4. If no, show login/register screen
5. On login success, store tokens securely
6. Add token to all API requests via interceptor
7. Auto-refresh token on 401 errors

## 📱 Key Screens

### Parent Flow

1. **Login/Register**
   - Email/password authentication
   - JWT token management

2. **Home Dashboard**
   - Statistics (children, vaccines, upcoming)
   - Quick actions
   - Recent activities

3. **Children List**
   - View all children
   - Add new child
   - Access child details

4. **Child Detail**
   - Complete profile information
   - Vaccination history
   - Documents
   - QR code display

5. **Vaccination History**
   - Timeline view
   - Vaccine details
   - Adverse reactions
   - Verification status

6. **Vaccination Schedule**
   - Upcoming vaccines
   - Due dates
   - Reminders

7. **QR Scanner**
   - Scan child QR code
   - Quick access to profile
   - Hospital-friendly interface

8. **Vial Scanner**
   - Scan vaccine vial barcode
   - Auto-fill vaccine details
   - Batch information

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Building for Release

### Android APK/Bundle

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Build for specific ABI
flutter build apk --target-platform android-arm64 --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA

```bash
# Build iOS app
flutter build ios --release

# Or build IPA
flutter build ipa --release
```

Output: `build/ios/iphoneos/Runner.app`

## 🚀 Deployment

### Android - Google Play Store

1. **Setup Signing**:
   - Create keystore: `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
   - Configure `android/key.properties`
   - Update `android/app/build.gradle`

2. **Build Bundle**:
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Play Console**:
   - Create app listing
   - Upload bundle
   - Complete store listing
   - Submit for review

### iOS - App Store

1. **Setup Certificates**:
   - Apple Developer account
   - App ID
   - Provisioning profiles

2. **Configure Xcode**:
   - Open `ios/Runner.xcworkspace`
   - Set signing & capabilities
   - Update bundle ID

3. **Build & Archive**:
   ```bash
   flutter build ipa --release
   ```

4. **Upload to App Store Connect**:
   - Use Xcode or Transporter
   - Complete app information
   - Submit for review

## 🔧 Configuration

### Environment Variables

Edit `lib/core/config/app_config.dart`:

```dart
static Future<void> initialize() async {
  if (kDebugMode) {
    // Development
    apiBaseUrl = 'http://10.0.2.2:8000';
    enableLogging = true;
  } else {
    // Production
    apiBaseUrl = 'https://api.vaccinationlocker.com';
    enableLogging = false;
  }
}
```

### Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for QR code scanning</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required to upload documents</string>
```

## 🎨 Customization

### Theme Colors

Edit `lib/core/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF0EA5E9);
static const Color secondaryColor = Color(0xFFD946EF);
```

### App Icon

1. Replace `assets/icons/app_icon.png` with your icon
2. Run: `flutter pub run flutter_launcher_icons`

### App Name

Update in:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

## 🐛 Troubleshooting

### Common Issues

**Dependency conflicts**:
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

**Build errors**:
```bash
cd android && ./gradlew clean
cd ios && pod deintegrate && pod install
```

**Code generation fails**:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Camera not working**:
- Check permissions in manifest/Info.plist
- Rebuild the app after adding permissions

## 📚 Dependencies

### Core
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `dio` - HTTP client
- `flutter_secure_storage` - Secure token storage
- `hive` - Local database

### UI
- `cached_network_image` - Image caching
- `shimmer` - Loading placeholders
- `flutter_svg` - SVG support

### Scanner
- `mobile_scanner` - QR/Barcode scanning
- `qr_flutter` - QR code generation
- `image_picker` - Image selection

### Notifications
- `flutter_local_notifications` - Local notifications
- `firebase_messaging` - Push notifications

### PDF & Documents
- `pdf` - PDF generation
- `printing` - PDF printing
- `file_picker` - File selection

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Write tests
5. Submit pull request

## 📄 License

MIT License

## 📞 Support

For support, email support@vaccinationlocker.com

## 🙏 Acknowledgments

- Flutter Team
- Riverpod Community
- All package contributors





