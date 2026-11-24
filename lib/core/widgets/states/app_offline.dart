import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppOffline extends StatelessWidget {
  const AppOffline({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Kamu sedang dalam mode offline',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Halaman ini membutuhkan koneksi internet. '
              'Hubungkan kembali perangkatmu untuk mengakses konten.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
