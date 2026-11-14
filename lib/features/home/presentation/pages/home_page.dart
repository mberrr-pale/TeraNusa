import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_popup.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),

        actions: [
          IconButton(
            // icon: const Icon(Icons.logout),
            icon: const Icon(Icons.person),
            tooltip: 'Logout',
            onPressed: () {
              context.push(AppRoutes.profile);
            },
            //   onPressed: () async {
            //     await AppPopUp.show(
            //       context: context,
            //       title: 'Konfirmasi Logout',
            //       message: 'Apakah kamu yakin ingin keluar dari akun?',
            //       type: AppPopupType.warning,
            //       confirmText: 'Ya, Logout',
            //       cancelText: 'Batal',

            //       onConfirm: () async {
            //         try {
            //           await ref.read(authProvider.notifier).logout();

            //           if (!context.mounted) return;

            //           context.go(AppRoutes.login);
            //         } catch (e) {
            //           if (!context.mounted) return;

            //           await AppPopUp.show(
            //             context: context,
            //             title: 'Logout Gagal',
            //             message:
            //                 'Terjadi kesalahan saat keluar dari akun. '
            //                 'Silakan coba kembali.',
            //             type: AppPopupType.error,
            //           );
            //         }
            //       },
            //     );
            //   },
          ),
        ],
      ),

      body: const Center(child: Text('Halaman Dashboard')),
    );
  }
}
