import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/contributor_application.dart';

extension ApplicationCategoryX on ApplicationCategory {
  String get label => switch (this) {
    ApplicationCategory.contributor => 'Kontributor',
    ApplicationCategory.regionalAdmin => 'Admin Wilayah',
  };

  String get pageTitle => switch (this) {
    ApplicationCategory.contributor => 'Pengajuan Kontributor',
    ApplicationCategory.regionalAdmin => 'Pengajuan Admin Wilayah',
  };

  String get badgeLabel => switch (this) {
    ApplicationCategory.contributor => 'AKSES KONTRIBUTOR',
    ApplicationCategory.regionalAdmin => 'AKSES ADMIN WILAYAH',
  };

  String get emptyMessage => switch (this) {
    ApplicationCategory.contributor => 'Belum ada pengajuan kontributor.',
    ApplicationCategory.regionalAdmin => 'Belum ada pengajuan admin wilayah.',
  };
}

extension ApplicationStatusX on ApplicationStatus {
  String get label => switch (this) {
    ApplicationStatus.pending => 'Menunggu',
    ApplicationStatus.approved => 'Disetujui',
    ApplicationStatus.rejected => 'Ditolak',
  };

  Color get color => switch (this) {
    ApplicationStatus.pending => const Color(0xFFC2661B),
    ApplicationStatus.approved => AppColors.primary,
    ApplicationStatus.rejected => const Color(0xFFC62828),
  };

  Color get background => switch (this) {
    ApplicationStatus.pending => const Color(0xFFFFEEDD),
    ApplicationStatus.approved => AppColors.primaryLight,
    ApplicationStatus.rejected => const Color(0xFFFDECEA),
  };

  IconData get icon => switch (this) {
    ApplicationStatus.pending => Icons.schedule,
    ApplicationStatus.approved => Icons.check_circle_outline,
    ApplicationStatus.rejected => Icons.cancel_outlined,
  };
}

const _months = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String formatSubmittedAt(DateTime date, {DateTime? now}) {
  final current = now ?? DateTime.now();

  final diff = DateTime(
    current.year,
    current.month,
    current.day,
  ).difference(DateTime(date.year, date.month, date.day)).inDays;

  final time =
      '${date.hour.toString().padLeft(2, '0')}.'
      '${date.minute.toString().padLeft(2, '0')}';

  if (diff == 0) return 'Hari ini · $time';
  if (diff == 1) return 'Kemarin · $time';

  final month = _months[date.month - 1];

  if (date.year == current.year) {
    return '${date.day} $month · $time';
  }

  return '${date.day} $month ${date.year} · $time';
}
