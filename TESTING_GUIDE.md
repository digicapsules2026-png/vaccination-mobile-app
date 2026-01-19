# Testing Guide - Vaccination Mobile App

Complete guide for testing the Vaccination Locker mobile application.

---

## Prerequisites

Before testing, ensure you have:

1. **Flutter SDK 3.0+** installed
   ```bash
   flutter --version
   ```

2. **Dart SDK 3.0+** (included with Flutter)
   ```bash
   dart --version
   ```

3. **Backend Server Running**
   - The vaccination-backend should be running and accessible
   - Default port: `8000`
   - Verify backend: `http://localhost:8000/health`

4. **Device or Emulator**
   - Android Emulator (Android Studio)
   - iOS Simulator (Xcode - macOS only)
   - Physical Android/iOS device

---

## Initial Setup

### 1. Install Dependencies

```bash
cd vaccination-mobile-app
flutter pub get
```

### 2. Generate Code

Generate required code for models, repositories, and providers:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Note**: If you encounter conflicts, add `--delete-conflicting-outputs` flag.

### 3. Check Flutter Setup

```bash
flutter doctor
```

Ensure all required components are installed and configured.

### 4. List Available Devices

```bash
flutter devices
```

You should see at least one device (emulator/simulator/physical device).

---

## Backend Configuration

### Update API Base URL

Edit `lib/core/config/app_config.dart` based on your testing environment:

#### For Android Emulator:
```dart
apiBaseUrl = 'http://10.0.2.2:8000'; // Android emulator maps localhost to 10.0.2.2
```

#### For iOS Simulator:
```dart
apiBaseUrl = 'http://localhost:8000'; // iOS simulator can access localhost directly
```

#### For Physical Device:
```dart
// Replace with your computer's local IP address
// Find your IP:
// Windows: ipconfig
// macOS/Linux: ifconfig or ip addr
apiBaseUrl = 'http://192.168.1.XXX:8000'; // Your local IP
```

#### For Backend on Different Machine/Port:
```dart
apiBaseUrl = 'http://<backend-ip>:<port>'; // e.g., 'http://192.168.1.100:8000'
```

### Verify Backend Connectivity

**Before running the app, test backend connection:**

1. **From Command Line (using curl):**
   ```bash
   # Windows PowerShell
   Invoke-WebRequest -Uri "http://localhost:8000/health"
   
   # Linux/macOS
   curl http://localhost:8000/health
   ```

2. **From Browser:**
   - Open: `http://localhost:8000/health`
   - Should return: `{"status":"healthy"}`

3. **Check API Docs:**
   - Open: `http://localhost:8000/api/v1/docs`
   - Swagger UI should load

---

## Running the App

### Run on Android Emulator

1. **Start Android Emulator:**
   ```bash
   # Via Android Studio or
   emulator -avd <emulator-name>
   ```

2. **Update API URL for Android:**
   ```dart
   // In app_config.dart
   apiBaseUrl = 'http://10.0.2.2:8000';
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Run on iOS Simulator (macOS only)

1. **Start iOS Simulator:**
   ```bash
   open -a Simulator
   # Or via Xcode
   ```

2. **Update API URL for iOS:**
   ```dart
   // In app_config.dart
   apiBaseUrl = 'http://localhost:8000';
   ```

3. **Install CocoaPods dependencies:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Run on Physical Device

1. **Enable Developer Options:**
   - Android: Settings → About Phone → Tap "Build Number" 7 times
   - iOS: Settings → General → Device Management → Trust Developer

2. **Enable USB Debugging:**
   - Android: Settings → Developer Options → Enable USB Debugging
   - Connect device via USB

3. **Find your computer's local IP:**
   ```bash
   # Windows
   ipconfig
   # Look for IPv4 Address (e.g., 192.168.1.100)
   
   # macOS/Linux
   ifconfig
   # or
   ip addr
   ```

4. **Update API URL:**
   ```dart
   // In app_config.dart, use your local IP
   apiBaseUrl = 'http://192.168.1.XXX:8000'; // Replace XXX with your IP
   ```

5. **Ensure device and computer are on same Wi-Fi network**

6. **Run the app:**
   ```bash
   flutter run
   ```

---

## Testing Checklist

### Authentication Testing

- [ ] **User Registration**
  - Navigate to Register page
  - Fill all required fields (name, email, password, phone)
  - Submit registration
  - Verify success message
  - Return to login page

- [ ] **User Login**
  - Enter registered email and password
  - Click Login button
  - Verify JWT token is stored securely
  - Navigate to Home/Dashboard

- [ ] **Login Error Handling**
  - Test with invalid email
  - Test with wrong password
  - Verify error messages are displayed

- [ ] **Logout**
  - Click logout option
  - Verify token is cleared
  - Redirect to login page

### Home Dashboard Testing

- [ ] **Dashboard Loads**
  - Verify "My Vaccinations" card is displayed
  - Verify "My Children" card is displayed
  - Check that counts and statistics are shown

- [ ] **My Vaccinations Card**
  - Click to view parent vaccination records
  - Verify navigation to parent beneficiary detail page

- [ ] **My Children Card**
  - Click to expand and view child list
  - Verify child count badge is shown
  - Click on individual child card
  - Verify navigation to child detail page

### Child Profile Management

- [ ] **Add Child Profile**
  - Navigate to "Add Child" page
  - Fill in all required fields:
    - Child name
    - Date of birth
    - Gender
    - Birth details (weight, height, head circumference, gestational age)
  - Submit form
  - Verify success message
  - Verify child appears in "My Children" list

- [ ] **View Child Detail**
  - Click on child from list
  - Verify Overview tab loads
  - Verify Vaccinations tab
  - Verify Timeline tab
  - Verify Documents tab

- [ ] **Edit Child Profile**
  - Navigate to child detail page
  - Click edit button
  - Modify child information
  - Save changes
  - Verify updated information is reflected

### Vaccination Timeline Testing

- [ ] **Timeline Display**
  - Navigate to Timeline tab for a child
  - Verify vaccines are listed by age
  - Verify status colors:
    - Green for "Administered"
    - Orange for "Due / Upcoming"
    - Grey for "Due Next"

- [ ] **Birth Dose Vaccines**
  - Verify BCG, Hepatitis B Birth Dose, OPV-0 show "Due at Birth" or "Given on <date>"
  - Verify NO date ranges for birth doses

- [ ] **Timeline Navigation**
  - Click on a vaccination card
  - Verify navigation to Vaccination Detail page

- [ ] **Download Timeline PDF**
  - Click Download button on Timeline
  - Verify PDF is generated
  - Verify PDF contains only "Administered" vaccines
  - Verify child details in PDF

- [ ] **Share Timeline**
  - Click Share button
  - Verify sharing dialog appears
  - Verify PDF can be shared via system share

### Vaccination Detail Page

- [ ] **View Vaccination Details**
  - Navigate to vaccination detail page
  - Verify vaccine information is displayed:
    - Vaccine name and dose
    - Disease prevented
    - Recommended age
    - Route and injection site
    - WHO/Indian UIP reference

- [ ] **Vaccination Record (if Administered)**
  - Verify vaccination date
  - Verify batch number (if available)
  - Verify hospital/clinic name
  - Verify administered by information

- [ ] **Vaccine Education Section**
  - Expand "Why this vaccination is given"
  - Verify educational content is displayed
  - Verify content is parent-friendly and accurate

- [ ] **Proof Upload (if Administered)**
  - Verify uploaded documents are displayed
  - Test document preview functionality

- [ ] **Edit Record (if Administered)**
  - Click Edit button
  - Modify vaccination details
  - Save changes
  - Verify updates are reflected

### Add Vaccination Record

- [ ] **Add New Vaccination**
  - Navigate to "Add Vaccination" page
  - Select beneficiary (child or parent)
  - Select vaccine and dose
  - Fill in vaccination details:
    - Date of vaccination
    - Batch number (optional)
    - Manufacturer (optional)
    - Hospital/clinic
  - Fill in mandatory vitals:
    - Temperature (with unit: °C or °F)
    - Weight (kg)
  - Add optional vitals if needed:
    - Height/Length
    - Pulse Rate
    - Oxygen Saturation
  - Upload proof document (optional)
  - Submit form
  - Verify vaccination appears in timeline with "Administered" status

### Document Locker Testing

- [ ] **View Documents**
  - Navigate to Documents tab for a child
  - Verify documents are organized by category
  - Verify document list loads

- [ ] **Upload Document**
  - Click "Upload Document" button
  - Select document type (Birth Certificate, Vaccination Card, etc.)
  - Choose file (PDF or image)
  - Upload document
  - Verify document appears in appropriate category

- [ ] **Preview Document**
  - Click on a document
  - Verify document preview opens
  - Verify PDF viewer or image viewer works

- [ ] **Download Document**
  - Click download icon on document
  - Verify file downloads successfully

- [ ] **Delete Document**
  - Click delete icon
  - Confirm deletion
  - Verify document is removed from list

### QR Code Scanning

- [ ] **QR Code Scanner**
  - Navigate to Scanner page
  - Grant camera permission if prompted
  - Scan a QR code from beneficiary detail page
  - Verify beneficiary information loads

- [ ] **Vial Scanner**
  - Navigate to Vial Scanner
  - Scan barcode/QR from vaccine vial
  - Verify vaccine details are auto-filled

### Reminders Testing

- [ ] **View Reminders**
  - Navigate to Reminders page
  - Verify upcoming reminders are listed
  - Verify reminder details (child name, vaccine, due date)

- [ ] **Reminder Settings**
  - Navigate to Reminder Settings
  - Enable/disable reminders for specific vaccines
  - Select notification channels (Push, SMS, Email)
  - Save settings
  - Verify settings are saved

### Immunization Reports

- [ ] **Generate Report**
  - Navigate to beneficiary detail page
  - Click "Download Report" or "Share Report"
  - Verify PDF is generated
  - Verify PDF contains only "Administered" vaccines
  - Verify report includes:
    - Beneficiary details
    - Complete vaccination history (administered only)
    - Hospital/clinic information
    - Dates and batch numbers

---

## Common Issues and Troubleshooting

### Issue: Cannot Connect to Backend

**Symptoms:**
- "Network error" messages
- API calls failing
- Loading indicators never complete

**Solutions:**

1. **Verify backend is running:**
   ```bash
   # Check backend logs
   # Verify port 8000 is accessible
   ```

2. **Check API URL configuration:**
   - Android Emulator: Use `http://10.0.2.2:8000`
   - iOS Simulator: Use `http://localhost:8000`
   - Physical Device: Use your computer's local IP (e.g., `http://192.168.1.100:8000`)

3. **Check firewall settings:**
   - Ensure port 8000 is not blocked
   - Allow Flutter/mobile app through firewall

4. **Verify network connectivity:**
   - Ensure device/emulator and backend are on same network
   - Test backend URL from device browser if possible

5. **Check CORS settings (if applicable):**
   - Backend should allow requests from mobile app origin

### Issue: Build Errors

**Symptoms:**
- `flutter pub get` fails
- Code generation errors
- Import errors

**Solutions:**

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Check Flutter/Dart versions:**
   ```bash
   flutter doctor
   flutter upgrade
   ```

3. **Delete generated files and regenerate:**
   ```bash
   # Delete .dart_tool and build folders
   rm -rf .dart_tool build
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Issue: Camera/Scanner Not Working

**Symptoms:**
- Camera permission denied
- Scanner page crashes
- No camera feed

**Solutions:**

1. **Check permissions in AndroidManifest.xml (Android):**
   ```xml
   <uses-permission android:name="android.permission.CAMERA"/>
   ```

2. **Check permissions in Info.plist (iOS):**
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>We need camera access to scan QR codes</string>
   ```

3. **Grant permissions manually:**
   - Android: Settings → Apps → Vaccination App → Permissions → Camera
   - iOS: Settings → Privacy → Camera → Vaccination App

4. **Rebuild after permission changes:**
   ```bash
   flutter clean
   flutter run
   ```

### Issue: PDF Generation Fails

**Symptoms:**
- PDF download button doesn't work
- PDF generation error messages
- Blank PDF files

**Solutions:**

1. **Check dependencies:**
   ```bash
   flutter pub get
   # Ensure pdf and printing packages are installed
   ```

2. **Check file permissions:**
   - Ensure app has storage permissions
   - Check available storage space

3. **Verify data exists:**
   - Ensure vaccination records exist before generating PDF
   - Check that beneficiary has administered vaccines

### Issue: App Crashes on Launch

**Symptoms:**
- App immediately closes after opening
- White/black screen
- Crash logs

**Solutions:**

1. **Check logs:**
   ```bash
   flutter logs
   # Look for error messages
   ```

2. **Verify code generation:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Check initialization:**
   - Verify `AppConfig.initialize()` is called in `main.dart`
   - Verify all required services are initialized

4. **Test on different device:**
   - Try emulator vs physical device
   - Try different Android/iOS versions

### Issue: State Not Updating

**Symptoms:**
- UI doesn't reflect data changes
- Old data persists after updates

**Solutions:**

1. **Hot restart (not just hot reload):**
   - Press `R` in terminal (capital R) or `Ctrl+Shift+F5` in VS Code

2. **Check Riverpod providers:**
   - Verify providers are watching state correctly
   - Check provider dependencies

3. **Clear app data:**
   - Uninstall and reinstall app
   - Or clear app data from device settings

---

## Testing on Different Scenarios

### Test with Multiple Children

1. Add 2-3 child profiles
2. Verify all children appear in "My Children" list
3. Test navigation between different child profiles
4. Verify vaccination timelines are child-specific
5. Test that data doesn't mix between children

### Test Offline Mode

1. Turn off Wi-Fi/mobile data
2. Verify app still launches
3. Verify read-only access to cached data
4. Verify error message for write operations
5. Turn network back on and verify sync

### Test with Different Screen Sizes

1. Test on small screens (phone)
2. Test on large screens (tablet)
3. Verify responsive layout
4. Verify all UI elements are accessible

### Test Error Scenarios

1. Test with backend server stopped
2. Test with invalid API responses
3. Test with slow network (throttle network)
4. Test with invalid user input
5. Verify error messages are user-friendly

---

## Performance Testing

### Load Testing

1. Add 10+ child profiles
2. Add 50+ vaccination records
3. Test timeline loading performance
4. Test document list with many files
5. Verify app remains responsive

### Memory Testing

1. Monitor memory usage during testing
2. Test with many images/documents loaded
3. Verify proper memory cleanup
4. Check for memory leaks using Flutter DevTools

---

## Useful Commands

```bash
# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (press 'r' while running)
r

# Hot restart (press 'R' while running)
R

# View logs
flutter logs

# Check for issues
flutter doctor

# Run tests
flutter test

# Build APK (Android)
flutter build apk

# Build IPA (iOS - requires macOS)
flutter build ios

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## Debugging Tips

1. **Use Flutter DevTools:**
   - Run: `flutter pub global activate devtools`
   - Open DevTools from VS Code or Android Studio

2. **Enable Debug Logging:**
   - Check `app_config.dart` → `enableLogging = true` in debug mode
   - View logs in terminal or DevTools console

3. **Use Breakpoints:**
   - Set breakpoints in VS Code or Android Studio
   - Step through code execution

4. **Network Inspection:**
   - Use Dio interceptor logs (if enabled)
   - Check network tab in DevTools

5. **State Inspection:**
   - Use Riverpod DevTools
   - Inspect provider state values

---

## Next Steps

After completing testing:

1. Document any bugs or issues found
2. Test edge cases and error scenarios
3. Perform user acceptance testing
4. Test on multiple devices and OS versions
5. Prepare for production deployment

---

## Support

For issues or questions:

1. Check [README.md](README.md) for detailed documentation
2. Review [QUICKSTART.md](QUICKSTART.md) for setup help
3. Check backend API documentation: `http://localhost:8000/api/v1/docs`
4. Review Flutter documentation: https://docs.flutter.dev

