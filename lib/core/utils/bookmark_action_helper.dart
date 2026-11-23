import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/internet_provider.dart';
import '../widgets/app_snackbar.dart';
import '../../features/saved/presentation/providers/saved_opportunity_provider.dart';

class BookmarkActionHelper {
  BookmarkActionHelper._();

  static Future<void> toggle({
    required BuildContext context,
    required WidgetRef ref,
    required String? opportunityId,
    required bool isSaved,
  }) async {
    // Validasi ID peluang.
    if (opportunityId == null || opportunityId.trim().isEmpty) {
      AppSnackBar.showError(
        context,
        title: 'Gagal memperbarui peluang',
        message: 'ID peluang tidak ditemukan.',
      );
      return;
    }

    // Periksa koneksi sebelum menjalankan aksi.
    if (ref.read(internetStatusProvider).asData?.value != true) {
      _showOfflineMessage(context);
      return;
    }

    try {
      await ref
          .read(savedOpportunityIdsProvider.notifier)
          .toggleSavedOpportunity(opportunityId);

      if (!context.mounted) return;

      // Notifikasi setelah aksi berhasil.
      AppSnackBar.showSuccess(
        context,
        title: isSaved
            ? 'Peluang berhasil dihapus'
            : 'Peluang berhasil disimpan',
        message: isSaved
            ? 'Peluang berhasil dihapus dari daftar tersimpan.'
            : 'Peluang berhasil disimpan ke daftar tersimpan.',
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);

      if (!context.mounted) return;

      if (e is OfflineSavedActionException) {
        _showOfflineMessage(context);
        return;
      }

      AppSnackBar.showError(
        context,
        title: 'Gagal memperbarui peluang',
        message: 'Terjadi kesalahan saat memperbarui peluang tersimpan.',
      );
    }
  }

  static void _showOfflineMessage(BuildContext context) {
    AppSnackBar.showError(
      context,
      title: 'Koneksi internet diperlukan',
      message: 'Hubungkan ke internet untuk mengubah daftar tersimpan.',
    );
  }
}
