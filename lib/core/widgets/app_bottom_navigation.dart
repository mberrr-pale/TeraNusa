import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../constants/app_routes.dart';
import 'guest_access_guard.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// BOTTOM NAV ITEM
class _BottomNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;
  final bool requiresLogin;
  final bool contributorOnly;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.route,
    this.activeIcon,
    this.requiresLogin = false,
    this.contributorOnly = false,
  });
}

// APP BOTTOM NAVIGATION
class AppBottomNavigation extends ConsumerWidget {
  const AppBottomNavigation({super.key});

  // MENU CONFIGURATION
  List<_BottomNavItem> _getMenuItems({required bool isContributor}) {
    return [
      const _BottomNavItem(
        label: 'Beranda',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        route: AppRoutes.home,
        requiresLogin: false,
      ),
      const _BottomNavItem(
        label: 'Peluang',
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        route: AppRoutes.opportunities,
        requiresLogin: false,
      ),
      const _BottomNavItem(
        label: 'Berita',
        icon: Icons.newspaper_outlined,
        route: AppRoutes.news,
        requiresLogin: false,
      ),

      // if (isContributor)
      //   const _BottomNavItem(
      //     label: 'Dashboard',
      //     icon: Icons.dashboard_outlined,
      //     activeIcon: Icons.dashboard,
      //     route: AppRoutes.contributorDashboard,
      //     requiresLogin: true,
      //     contributorOnly: true,
      //   ),
      const _BottomNavItem(
        label: 'Profil',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        route: AppRoutes.profile,
        requiresLogin: true,
      ),
    ];
  }

  // NAVIGATION
  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref,
    _BottomNavItem item,
  ) async {
    if (item.requiresLogin) {
      final allowed = await GuestAccessGuard.check(context, ref);

      if (!allowed || !context.mounted) return;
    }

    if (item.contributorOnly) {
      final profile = ref.read(authProvider).asData?.value;

      if (profile?.isContributor != true) return;
    }

    if (!context.mounted) return;

    context.go(item.route);
  }

  // BUILD
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final isContributor = authState.asData?.value?.isContributor == true;

    final menuItems = _getMenuItems(isContributor: isContributor);

    // Get current route directly from GoRouter.
    final router = GoRouter.of(context);
    final currentRoute = router.routerDelegate.currentConfiguration.uri.path;

    // Find active menu.
    final activeIndex = menuItems.indexWhere(
      (item) => item.route == currentRoute,
    );

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: activeIndex >= 0 ? activeIndex : 0,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondaryText,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: (index) {
        _onTap(context, ref, menuItems[index]);
      },
      items: menuItems.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon ?? item.icon),
          label: item.label,
        );
      }).toList(),
    );
  }
}
