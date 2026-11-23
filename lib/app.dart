import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/internet_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_dialog.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isOfflineDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(internetStatusProvider, (previous, next) {
      final wasOnline = previous?.asData?.value == true;
      final isOffline = next.asData?.value == false;

      // Dialog hanya muncul saat status berubah dari online ke offline.
      if (!wasOnline || !isOffline || _isOfflineDialogShowing) {
        return;
      }

      _isOfflineDialogShowing = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOfflineDialog();
      });
    });

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'TeraNusa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }

  Future<void> _showOfflineDialog() async {
    try {
      if (!mounted) return;

      final navigatorContext = AppRouter.rootNavigatorKey.currentContext;

      if (navigatorContext == null) return;

      await AppDialog.show(
        navigatorContext,
        title: 'Kamu sedang offline',
        message:
            'Beberapa fitur sementara tidak tersedia. Kamu tetap bisa '
            'mengakses peluang yang sudah disimpan di halaman tersimpan.',
        type: AppDialogType.warning,
        confirmLabel: 'Mengerti',
        showCloseButton: true,
        barrierDismissible: true,
      );
    } finally {
      _isOfflineDialogShowing = false;
    }
  }
}
