import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_popup.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class GuestAccessGuard {
  GuestAccessGuard._();

  static bool isGuest(WidgetRef ref) {
    final authState = ref.read(authProvider);

    return authState.asData?.value == null;
  }

  static Future<bool> check(BuildContext context, WidgetRef ref) async {
    final authState = ref.read(authProvider);

    // Authentication masih loading atau error.
    if (authState.isLoading || authState.hasError) {
      return false;
    }

    // User sudah login.
    if (authState.asData?.value != null) {
      return true;
    }

    // User adalah guest.
    if (!context.mounted) return false;

    await AppPopUp.show(
      context: context,
      type: AppPopupType.warning,
      title: 'Login Diperlukan',
      message: 'Silakan login terlebih dahulu untuk menggunakan fitur ini.',
      confirmText: 'Login',
      cancelText: 'Nanti',
      barrierDismissible: true,
      onConfirm: () {
        if (context.mounted) {
          context.go(AppRoutes.login);
        }
      },
    );

    return false;
  }
}
