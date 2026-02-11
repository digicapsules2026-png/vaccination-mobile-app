import 'package:flutter/foundation.dart';

class AppConfig {
  static late String apiBaseUrl;
  static late String apiVersion;
  static late String environment;
  static late bool enableLogging;

  static Future<void> initialize() async {
    // In production, load from environment variables or config file
    // For now, using const values
    if (kDebugMode) {
      // Development
      apiBaseUrl = 'http://10.0.2.2:8000'; // Android emulator
      // apiBaseUrl = 'http://localhost:8000'; // iOS simulator
      apiVersion = 'v1';
      environment = 'development';
      enableLogging = true;
    } else {
      // Production
      apiBaseUrl = 'https://api.vaccinationlocker.com';
      apiVersion = 'v1';
      environment = 'production';
      enableLogging = false;
    }
  }

  static String get fullApiUrl => '$apiBaseUrl/api/$apiVersion';
  static String get v2ApiUrl => '$apiBaseUrl/api/v2';
}

class AppConstants {
  // App Info
  static const String appName = 'Vaccination Locker';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // File Upload
  static const int maxFileSizeMB = 10;
  static const List<String> allowedFileTypes = ['pdf', 'jpg', 'jpeg', 'png'];

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';
}















