import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../services/auth_service.dart';
import '../../features/beneficiaries/data/services/beneficiaries_service.dart';
import '../../features/vaccinations/data/services/vaccinations_service.dart';
import '../../features/vaccines/data/services/vaccines_service.dart';
import '../../features/documents/data/services/documents_service.dart';
import '../../features/reminders/data/services/reminders_service.dart';

// API Client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiClient(authService);
});

// Service providers
final beneficiariesServiceProvider = Provider<BeneficiariesService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BeneficiariesService(apiClient);
});

final vaccinationsServiceProvider = Provider<VaccinationsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VaccinationsService(apiClient);
});

final documentsServiceProvider = Provider<DocumentsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DocumentsService(apiClient);
});

final remindersServiceProvider = Provider<RemindersService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemindersService(apiClient);
});

final vaccinesServiceProvider = Provider<VaccinesService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VaccinesService(apiClient);
});

