import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/services/auth_service.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final apiClient = ApiClient(authService);
  return AuthRepository(apiClient.dio, authService);
});

class AuthRepository {
  final Dio _dio;
  final AuthService _authService;

  AuthRepository(this._dio, this._authService);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final tokens = AuthTokens.fromJson(response.data);
      await _authService.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      // Get user profile
      final user = await getCurrentUser();
      await _authService.saveUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'parent',
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone': phone,
        'role': role,
      });

      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } finally {
      await _authService.clearAuth();
    }
  }
}











