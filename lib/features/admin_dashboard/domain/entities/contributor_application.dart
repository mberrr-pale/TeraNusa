enum ApplicationStatus {
  pending,
  approved,
  rejected;

  static ApplicationStatus fromValue(String value) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ApplicationStatus.pending,
    );
  }
}

enum ApplicationCategory {
  contributor,
  regionalAdmin;

  static ApplicationCategory fromValue(String value) {
    return ApplicationCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ApplicationCategory.contributor,
    );
  }
}

class ContributorApplication {
  final String id;
  final String fullName;
  final String roleLabel;
  final ApplicationCategory category;
  final String position;
  final String institution;
  final String email;
  final String phone;
  final String region;
  final String reason;
  final DateTime submittedAt;
  final ApplicationStatus status;
  final String? adminNote;
  final DateTime? reviewedAt;

  const ContributorApplication({
    required this.id,
    required this.fullName,
    required this.roleLabel,
    required this.category,
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

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) return '?';

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

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
      category: category,
      position: position,
      institution: institution,
      email: email,
      phone: phone,
      region: region,
      reason: reason,
      submittedAt: submittedAt,
      status: status ?? this.status,
      adminNote: clearAdminNote ? null : adminNote ?? this.adminNote,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}

extension ApplicationCategoryExtension on ApplicationCategory {
  String get pageTitle {
    switch (this) {
      case ApplicationCategory.contributor:
        return 'Pengajuan Kontributor';
      case ApplicationCategory.regionalAdmin:
        return 'Pengajuan Admin Wilayah';
    }
  }

  String get badgeLabel {
    switch (this) {
      case ApplicationCategory.contributor:
        return 'KONTRIBUTOR';
      case ApplicationCategory.regionalAdmin:
        return 'ADMIN WILAYAH';
    }
  }

  String get emptyMessage {
    switch (this) {
      case ApplicationCategory.contributor:
        return 'Belum ada pengajuan kontributor.';
      case ApplicationCategory.regionalAdmin:
        return 'Belum ada pengajuan Admin Wilayah.';
    }
  }
}
