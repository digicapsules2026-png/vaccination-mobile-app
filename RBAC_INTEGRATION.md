# RBAC Integration Guide - Mobile App

## Overview

This guide explains how to integrate the multi-facility RBAC system into the Flutter mobile application.

## Authentication Updates

### Update Auth Model

```dart
// lib/models/auth_user.dart
class AuthUser {
  final int userId;
  final String mobileNumber;
  final String role; // Legacy
  final String loginType;
  final List<int> facilityIds;
  final Map<int, String> facilityRoles; // { facilityId: 'facility_admin' | 'doctor' | 'staff' }
  final bool isSuperAdmin;
  
  AuthUser({
    required this.userId,
    required this.mobileNumber,
    required this.role,
    required this.loginType,
    required this.facilityIds,
    required this.facilityRoles,
    required this.isSuperAdmin,
  });
  
  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['user_id'] as int,
      mobileNumber: json['mobile_number'] as String,
      role: json['role'] as String,
      loginType: json['login_type'] as String,
      facilityIds: (json['facility_ids'] as List<dynamic>?)?.cast<int>() ?? [],
      facilityRoles: (json['facility_roles'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(int.parse(k), v as String)
      ) ?? {},
      isSuperAdmin: json['is_super_admin'] as bool? ?? false,
    );
  }
  
  // Helper methods
  bool isFacilityAdmin(int facilityId) {
    return facilityRoles[facilityId] == 'facility_admin' || isSuperAdmin;
  }
  
  bool isDoctor(int facilityId) {
    return facilityRoles[facilityId] == 'doctor' || isFacilityAdmin(facilityId);
  }
  
  bool isStaff(int facilityId) {
    return facilityRoles[facilityId] == 'staff' || isDoctor(facilityId);
  }
}
```

## Facility Selection

### Facility Selector Widget

```dart
// lib/widgets/facility_selector.dart
import 'package:flutter/material.dart';
import '../models/auth_user.dart';
import '../providers/auth_provider.dart';

class FacilitySelector extends StatelessWidget {
  final Function(int) onFacilitySelected;
  
  const FacilitySelector({Key? key, required this.onFacilitySelected}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider.of(context);
    final user = authProvider.currentUser;
    
    if (user == null || user.facilityIds.length <= 1) {
      return SizedBox.shrink(); // No selector needed
    }
    
    return DropdownButton<int>(
      value: authProvider.selectedFacilityId ?? user.facilityIds.first,
      items: user.facilityIds.map((facilityId) {
        return DropdownMenuItem<int>(
          value: facilityId,
          child: Text('Facility $facilityId'),
        );
      }).toList(),
      onChanged: (facilityId) {
        if (facilityId != null) {
          authProvider.setSelectedFacility(facilityId);
          onFacilitySelected(facilityId);
        }
      },
    );
  }
}
```

## Role-Based UI

### Doctor View

```dart
// lib/features/vaccinations/presentation/pages/doctor_vaccination_page.dart
import 'package:flutter/material.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DoctorVaccinationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider.of(context);
    final user = authProvider.currentUser;
    final facilityId = authProvider.selectedFacilityId;
    
    if (user == null || facilityId == null || !user.isDoctor(facilityId)) {
      return Scaffold(
        body: Center(child: Text('Access Denied')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text('Vaccinations')),
      body: VaccinationList(facilityId: facilityId),
    );
  }
}
```

### Staff View

```dart
// lib/features/vaccinations/presentation/pages/staff_vaccination_page.dart
import 'package:flutter/material.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class StaffVaccinationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider.of(context);
    final user = authProvider.currentUser;
    final facilityId = authProvider.selectedFacilityId;
    
    if (user == null || facilityId == null || !user.isStaff(facilityId)) {
      return Scaffold(
        body: Center(child: Text('Access Denied')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text('Assist with Vaccinations')),
      body: StaffVaccinationAssist(facilityId: facilityId),
    );
  }
}
```

## API Service Updates

```dart
// lib/core/network/api_client.dart
class ApiClient {
  final String baseUrl;
  final AuthProvider authProvider;
  
  ApiClient({required this.baseUrl, required this.authProvider});
  
  Future<Map<String, dynamic>> getFacilityAnalytics(int facilityId) async {
    final token = await authProvider.getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/analytics/facility/$facilityId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load analytics');
    }
  }
  
  Future<List<Map<String, dynamic>>> getFacilityVaccinations(int facilityId) async {
    final token = await authProvider.getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/vaccinations?facility_id=$facilityId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load vaccinations');
    }
  }
}
```

## Navigation Updates

```dart
// lib/core/router/app_router.dart
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final authProvider = AuthProvider.of(settings.arguments as BuildContext);
    final user = authProvider.currentUser;
    final facilityId = authProvider.selectedFacilityId;
    
    switch (settings.name) {
      case '/doctor':
        if (user != null && facilityId != null && user.isDoctor(facilityId)) {
          return MaterialPageRoute(builder: (_) => DoctorDashboard());
        }
        return MaterialPageRoute(builder: (_) => AccessDeniedPage());
        
      case '/staff':
        if (user != null && facilityId != null && user.isStaff(facilityId)) {
          return MaterialPageRoute(builder: (_) => StaffDashboard());
        }
        return MaterialPageRoute(builder: (_) => AccessDeniedPage());
        
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
```

## State Management

```dart
// lib/providers/facility_provider.dart
import 'package:flutter/foundation.dart';

class FacilityProvider extends ChangeNotifier {
  int? _selectedFacilityId;
  final AuthProvider authProvider;
  
  FacilityProvider({required this.authProvider});
  
  int? get selectedFacilityId => _selectedFacilityId;
  
  void setSelectedFacility(int facilityId) {
    if (authProvider.currentUser?.facilityIds.contains(facilityId) ?? false) {
      _selectedFacilityId = facilityId;
      notifyListeners();
    }
  }
  
  void initializeFacility() {
    final user = authProvider.currentUser;
    if (user != null && user.facilityIds.isNotEmpty) {
      _selectedFacilityId = user.facilityIds.first;
      notifyListeners();
    }
  }
}
```

## Testing

```dart
// test/features/auth/auth_user_test.dart
void main() {
  group('AuthUser', () {
    test('isDoctor returns true for doctor role', () {
      final user = AuthUser(
        userId: 1,
        mobileNumber: '+919876543210',
        role: 'hospital',
        loginType: 'hospital',
        facilityIds: [1],
        facilityRoles: {1: 'doctor'},
        isSuperAdmin: false,
      );
      
      expect(user.isDoctor(1), true);
      expect(user.isFacilityAdmin(1), false);
    });
  });
}
```

## Notes

- **No Admin Features on Mobile**: SUPER_ADMIN and FACILITY_ADMIN features are web-only
- **Facility Context**: All API calls should include `facility_id` when applicable
- **Role Checks**: Always verify role on both frontend and backend
- **Multi-Facility**: Users with multiple facilities should select facility on login

