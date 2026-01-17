# Quick Start Guide

Get the Vaccination Locker Mobile App running in 10 minutes!

## 🚀 Prerequisites

- Flutter SDK installed
- VS Code or Android Studio
- Android Emulator or iOS Simulator running

## 📱 Quick Setup

```bash
# 1. Clone repository
git clone <repository-url>
cd vaccination-mobile-app

# 2. Install dependencies
flutter pub get

# 3. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Check devices
flutter devices

# 5. Run the app
flutter run
```

## ⚙️ Configure Backend URL

Edit `lib/core/config/app_config.dart`:

```dart
// For Android Emulator
apiBaseUrl = 'http://10.0.2.2:8000';

// For iOS Simulator  
apiBaseUrl = 'http://localhost:8000';

// For your device (use your computer's IP)
apiBaseUrl = 'http://192.168.1.100:8000';
```

## 📝 First Time Setup

### 1. Register Account
1. Open app
2. Click "Register here"
3. Fill in details
4. Submit registration
5. Return to login

### 2. Login
1. Enter email/password
2. Click "Login"
3. Navigate to home dashboard

### 3. Add Child
1. Go to "My Children"
2. Click "Add Child" button
3. Fill in child details
4. Submit form

### 4. View Features
- **Home**: See dashboard statistics
- **Children**: Manage child profiles
- **Scanner**: Scan QR codes
- **Schedule**: View upcoming vaccines

## 🐛 Troubleshooting

### Can't connect to backend?
```bash
# Check backend is running on correct port
# Use correct IP address for your device
```

### Build errors?
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Camera not working?
- Check permissions in AndroidManifest.xml (Android)
- Check Info.plist (iOS)
- Rebuild after permission changes

## 📚 Next Steps

- Read full [README.md](README.md)
- Explore feature documentation
- Customize theme colors
- Setup push notifications

## 💡 Tips

- Use hot reload (press 'r' in terminal)
- Use hot restart (press 'R' in terminal)
- Check Flutter DevTools for debugging
- Use VS Code Flutter extension

## 🔗 Useful Commands

```bash
# Run on specific device
flutter run -d <device-id>

# Build APK
flutter build apk

# Run tests
flutter test

# Check for issues
flutter doctor

# View logs
flutter logs
```

## 📞 Need Help?

- Check [README.md](README.md) for detailed docs
- Visit Flutter docs: https://docs.flutter.dev
- Check backend API: http://localhost:8000/api/v1/docs





