import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import 'router_refresh_notifier.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/home_page.dart';
import '../../features/search_filter/opportunity_page.dart';
import '../../features/news/news_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/opportunity_detail/opportunity_detail_page.dart';
import '../../data/models/opportunity.dart';

// Router Refresh Provider
final routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier();

  ref.listen(authProvider, (previous, next) {
    notifier.refresh();
  });

  ref.onDispose(notifier.dispose);

  return notifier;
});

// App Router Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshProvider);

  final router = GoRouter(
    initialLocation: AppRoutes.home,

    navigatorKey: AppRouter.rootNavigatorKey,
    refreshListenable: refreshNotifier,

    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // Tunggu sampai status autentikasi selesai diperiksa.
      if (authState.isLoading) {
        return null;
      }

      // Jangan menganggap kegagalan sinkronisasi profile
      // sebagai kondisi guest.
      if (authState.hasError) {
        return null;
      }

      final isAuthenticated = authState.asData?.value != null;

      final currentLocation = state.matchedLocation;

      final isLogin = currentLocation == AppRoutes.login;
      final isRegister = currentLocation == AppRoutes.register;

      // Halaman yang boleh diakses tanpa login.
      final isGuestAllowed =
          currentLocation == AppRoutes.home ||
          currentLocation == AppRoutes.opportunities ||
          currentLocation == AppRoutes.news;

      final isPublicPage = isLogin || isRegister || isGuestAllowed;

      // Guest hanya boleh mengakses halaman publik.
      if (!isAuthenticated && !isPublicPage) {
        return AppRoutes.home;
      }

      // User yang sudah login tidak perlu kembali
      // ke halaman login atau register.
      if (isAuthenticated && (isLogin || isRegister)) {
        return AppRoutes.home;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) {
          return const RegisterPage();
        },
      ),

      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: AppRoutes.home,
        name: 'dashboard',
        builder: (context, state) {
          return const HomePage();
        },
      ),

      GoRoute(
        path: AppRoutes.opportunities,
        name: 'opportunities',
        builder: (context, state) {
          return const OpportunityPage();
        },
      ),

      GoRoute(
        path: AppRoutes.opportunityDetail,
        name: 'opportunityDetail',
        builder: (context, state) {
          final opportunity = state.extra as Opportunity;

          return OpportunityDetailPage(opportunity: opportunity);
        },
      ),

      GoRoute(
        path: AppRoutes.news,
        name: 'news',
        builder: (context, state) {
          return const NewsPage();
        },
      ),

      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) {
          return const ProfilePage();
        },
      ),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Halaman tidak ditemukan: ${state.uri.path}')),
      );
    },
  );

  ref.onDispose(router.dispose);

  return router;
});

// AppRouter
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}
