enum ContributorRequestStatus {
  pending,
  approved,
  rejected;

  static ContributorRequestStatus fromString(String value) {
    return ContributorRequestStatus.values.firstWhere(
      (status) => status.name == value.toLowerCase(),
      orElse: () =>
          throw FormatException('Status pengajuan tidak dikenal: $value'),
    );
  }
}

class ContributorRequest {
  final String applicationId;
  final String userId;
  final String regionId;
  final ContributorRequestStatus status;
  final String? message;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  // Informasi profil pemohon
  final String? applicantName;
  final String? applicantEmail;
  final String? applicantAvatar;

  const ContributorRequest({
    required this.applicationId,
    required this.userId,
    required this.regionId,
    required this.status,
    this.message,
    this.rejectionReason,
    required this.createdAt,
    this.reviewedAt,
    this.applicantName,
    this.applicantEmail,
    this.applicantAvatar,
  });

  DateTime? get canReapplyAt {
    if (status != ContributorRequestStatus.rejected || reviewedAt == null) {
      return null;
    }

    return reviewedAt!.add(const Duration(days: 7));
  }

  bool get canReapply {
    final deadline = canReapplyAt;
    if (deadline == null) return false;
    return !DateTime.now().isBefore(deadline);
  }
}
