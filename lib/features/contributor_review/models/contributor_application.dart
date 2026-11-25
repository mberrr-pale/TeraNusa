import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum ApplicationStatus { pending, approved, rejected }

enum ApplicationCategory { contributor, regionalAdmin }

/// Token tampilan untuk setiap kategori pengajuan.
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

/// Token tampilan untuk setiap status pengajuan (label, warna, dan ikon).
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

/// Data pengajuan kontributor bersifat IMMUTABLE (read-only).
/// Hanya field keputusan admin ([status], [adminNote], [reviewedAt]) yang dapat
/// diperbarui melalui [copyWith].
class ContributorApplication {
  final String id;
  final String fullName;
  final String roleLabel;
  final String position;
  final String institution;
  final String email;
  final String phone;
  final String region;
  final String reason;
  final DateTime submittedAt;

  // Hasil keputusan admin (hanya 3 field ini yang boleh berubah)
  final ApplicationStatus status;
  final String? adminNote;
  final DateTime? reviewedAt;

  const ContributorApplication({
    required this.id,
    required this.fullName,
    required this.roleLabel,
    required this.position,
    required this.institution,
    required this.email,
    required this.phone,
    required this.region,
    required this.reason,
    required this.submittedAt,
    this.status = ApplicationStatus.pending,
    this.adminNote,
    this.reviewedAt,
  });

  /// Kategori pengajuan diturunkan dari [roleLabel] agar tetap read-only dan
  /// kompatibel dengan konstruktor yang sudah ada.
  ApplicationCategory get category =>
      roleLabel.toLowerCase().contains('admin wilayah')
      ? ApplicationCategory.regionalAdmin
      : ApplicationCategory.contributor;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  /// Menyalin objek hanya dengan pembaruan field keputusan admin.
  ContributorApplication copyWith({
    ApplicationStatus? status,
    String? adminNote,
    bool clearAdminNote = false,
    DateTime? reviewedAt,
  }) {
    return ContributorApplication(
      id: id,
      fullName: fullName,
      roleLabel: roleLabel,
      position: position,
      institution: institution,
      email: email,
      phone: phone,
      region: region,
      reason: reason,
      submittedAt: submittedAt,
      status: status ?? this.status,
      adminNote: clearAdminNote ? null : (adminNote ?? this.adminNote),
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}

const _indonesianMonths = <String>[
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

/// Format waktu pengiriman yang mudah dibaca admin:
/// "Hari ini · 09.42", "Kemarin · 14.18", "17 Juni · 11.05",
/// atau "17 Juni 2025 · 11.05" bila tahun berbeda.
String formatSubmittedAt(DateTime d, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final diff = DateTime(
    n.year,
    n.month,
    n.day,
  ).difference(DateTime(d.year, d.month, d.day)).inDays;
  final time =
      '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';
  if (diff == 0) return 'Hari ini · $time';
  if (diff == 1) return 'Kemarin · $time';
  final monthName = _indonesianMonths[d.month - 1];
  if (d.year == n.year) {
    return '${d.day} $monthName · $time';
  }
  return '${d.day} $monthName ${d.year} · $time';
}
