# Code Generation Guide

This guide explains how to run code generation for the Flutter mobile app to generate Freezed models, JSON serialization, and other generated code.

## Prerequisites

Make sure you have all dependencies installed:

```bash
flutter pub get
```

## Running Code Generation

### 1. Generate All Code (Recommended)

This command will generate code for all models and clean any conflicting files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Watch Mode (Development)

For active development, use watch mode to automatically regenerate code when files change:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 3. Clean Build

If you encounter issues, clean the build first:

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## What Gets Generated

The code generation creates the following files:

### Freezed Models
- `*.freezed.dart` files for all `@freezed` classes
- Immutable data classes with copyWith, equality, and toString methods

### JSON Serialization
- `*.g.dart` files for JSON serialization
- `fromJson` and `toJson` methods for all models

### Models That Need Generation

1. **Beneficiary Models**
   - `lib/features/beneficiaries/data/models/beneficiary_model.dart`
   - `lib/features/beneficiaries/data/models/timeline_model.dart`

2. **Vaccination Models**
   - `lib/features/vaccinations/data/models/vaccination_model.dart`
   - `lib/features/vaccines/data/models/vaccine_model.dart`

3. **Document Models**
   - `lib/features/documents/data/models/document_model.dart`

4. **Reminder Models**
   - `lib/features/reminders/data/models/reminder_model.dart`

5. **Child Model**
   - `lib/features/children/data/models/child_model.dart`

## Troubleshooting

### Issue: "Conflict with existing file"

**Solution:** Use the `--delete-conflicting-outputs` flag:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: "Build failed"

**Solution:**
1. Clean the build: `flutter pub run build_runner clean`
2. Get dependencies: `flutter pub get`
3. Rebuild: `flutter pub run build_runner build --delete-conflicting-outputs`

### Issue: "Cannot find generated file"

**Solution:** Make sure the part directives in your model files match:
```dart
part 'model_name.freezed.dart';
part 'model_name.g.dart';
```

### Issue: "Import errors"

**Solution:** 
1. Ensure all required packages are in `pubspec.yaml`
2. Run `flutter pub get`
3. Re-run code generation

## Required Dependencies

Make sure these are in your `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.8
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

## After Code Generation

1. **Review Generated Files**: Check that all `.freezed.dart` and `.g.dart` files are created
2. **Run Tests**: Verify everything compiles: `flutter analyze`
3. **Test App**: Run the app to ensure models work correctly: `flutter run`

## CI/CD Integration

For CI/CD pipelines, add this step:

```yaml
- name: Generate code
  run: flutter pub run build_runner build --delete-conflicting-outputs
```

## Best Practices

1. **Always commit generated files** to version control
2. **Don't edit generated files** manually - they will be overwritten
3. **Run generation before commits** if you've modified models
4. **Use watch mode** during active development for faster iteration

## Quick Reference

```bash
# Full rebuild
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean build
flutter pub run build_runner clean
```

