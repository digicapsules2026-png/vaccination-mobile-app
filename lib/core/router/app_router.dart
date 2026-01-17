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
import '../../features/scanner/presentation/pages/qr_scanner_page.dart';
import '../../features/scanner/presentation/pages/vial_scanner_page.dart';
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

      // Scanner routes
      GoRoute(
        path: '/scanner/qr',
        builder: (context, state) => const QRScannerPage(),
      ),
      GoRoute(
        path: '/scanner/vial',
        builder: (context, state) => const VialScannerPage(),
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





