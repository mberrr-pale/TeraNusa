enum ReportStatus {
  pending,
  reviewed,
  resolved,
  rejected;

  static ReportStatus fromString(String value) {
    switch (value) {
      case 'reviewed':
        return ReportStatus.reviewed;
      case 'resolved':
        return ReportStatus.resolved;
      case 'rejected':
        return ReportStatus.rejected;
      default:
        return ReportStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case ReportStatus.pending:
        return 'pending';
      case ReportStatus.reviewed:
        return 'reviewed';
      case ReportStatus.resolved:
        return 'resolved';
      case ReportStatus.rejected:
        return 'rejected';
    }
  }

  String get label {
    switch (this) {
      case ReportStatus.pending:
        return 'Menunggu';
      case ReportStatus.reviewed:
        return 'Diperiksa';
      case ReportStatus.resolved:
        return 'Selesai';
      case ReportStatus.rejected:
        return 'Ditolak';
    }
  }
}

class OpportunityReport {
  final String reportId;
  final String opportunityId;
  final String reporterUserId;
  final String reason;
  final String? description;
  final ReportStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? adminNote;
  final DateTime createdAt;
  final Map<String, dynamic> profiles;

  const OpportunityReport({
    required this.reportId,
    required this.opportunityId,
    required this.reporterUserId,
    required this.reason,
    this.description,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.adminNote,
    required this.createdAt,
    required this.profiles,
  });
}
