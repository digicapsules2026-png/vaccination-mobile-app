import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/children/presentation/pages/children_list_page.dart';
import '../../features/children/presentation/pages/child_detail_page.dart';
import '../../features/children/presentation/pages/add_child_page.dart';
import '../../features/vaccinations/presentation/pages/vaccination_list_page.dart';
import '../../features/vaccinations/presentation/pages/vaccination_detail_page.dart';
import '../../features/vaccinations/presentation/pages/add_vaccination_page.dart';
import '../../features/beneficiaries/presentation/pages/beneficiary_detail_page.dart';
import '../../features/reminders/presentation/pages/reminders_page.dart';
import '../../features/reminders/presentation/pages/reminder_settings_page.dart';
import '../../features/scanner/presentation/pages/qr_scanner_page.dart';
import '../../features/scanner/presentation/pages/vial_scanner_page.dart';
import '../../features/marketplace/presentation/pages/marketplace_search_page.dart';
import '../../features/marketplace/presentation/pages/listing_detail_page.dart';
import '../../features/marketplace/presentation/pages/bookings_list_page.dart';
import '../../features/marketplace/presentation/pages/booking_detail_page.dart';
import '../../features/marketplace/presentation/pages/payment_page.dart';
import '../services/auth_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute && state.matchedLocation != '/splash') {
        return '/auth/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Auth routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Main app routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),

      // Children routes
      GoRoute(
        path: '/children',
        builder: (context, state) => const ChildrenListPage(),
      ),
      GoRoute(
        path: '/children/add',
        builder: (context, state) => const AddChildPage(),
      ),
      GoRoute(
        path: '/children/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChildDetailPage(childId: int.parse(id));
        },
      ),

      // Vaccinations
      GoRoute(
        path: '/vaccinations/:childId',
        builder: (context, state) {
          final childId = state.pathParameters['childId']!;
          return VaccinationListPage(childId: int.parse(childId));
        },
      ),
      GoRoute(
        path: '/vaccinations/:id/detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VaccinationDetailPage(vaccinationId: int.parse(id));
        },
      ),
      GoRoute(
        path: '/vaccinations/new',
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final childId = queryParams['childId'] != null ? int.parse(queryParams['childId']!) : null;
          final beneficiaryId = queryParams['beneficiaryId'] != null ? int.parse(queryParams['beneficiaryId']!) : null;
          return AddVaccinationPage(childId: childId, beneficiaryId: beneficiaryId);
        },
      ),

      // Beneficiaries
      GoRoute(
        path: '/beneficiaries/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BeneficiaryDetailPage(beneficiaryId: int.parse(id));
        },
      ),

      // Reminders
      GoRoute(
        path: '/reminders/:beneficiaryId',
        builder: (context, state) {
          final beneficiaryId = state.pathParameters['beneficiaryId']!;
          return RemindersPage(beneficiaryId: int.parse(beneficiaryId));
        },
      ),
      GoRoute(
        path: '/reminders/:beneficiaryId/settings',
        builder: (context, state) {
          final beneficiaryId = state.pathParameters['beneficiaryId']!;
          return ReminderSettingsPage(beneficiaryId: int.parse(beneficiaryId));
        },
      ),

      // Scanner routes
      GoRoute(
        path: '/scanner/qr',
        builder: (context, state) => const QRScannerPage(),
      ),
      GoRoute(
        path: '/scanner/vial',
        builder: (context, state) => const VialScannerPage(),
      ),

      // Marketplace routes (MVP-2)
      GoRoute(
        path: '/marketplace',
        builder: (context, state) => const MarketplaceSearchPage(),
      ),
      GoRoute(
        path: '/marketplace/listing/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ListingDetailPage(listingId: int.parse(id));
        },
      ),
      GoRoute(
        path: '/marketplace/bookings',
        builder: (context, state) => const BookingsListPage(),
      ),
      GoRoute(
        path: '/marketplace/booking/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingDetailPage(bookingId: int.parse(id));
        },
      ),
      GoRoute(
        path: '/marketplace/booking/:id/payment',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PaymentPage(bookingId: int.parse(id));
        },
      ),
    ],
  );
});

// Splash page placeholder
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}





