enum OpportunityReviewStatus {
  normal,
  pendingReview,
  underReview,
  approved,
  rejected,
  takenDown;

  static OpportunityReviewStatus fromString(String value) {
    switch (value) {
      case 'pending_review':
        return OpportunityReviewStatus.pendingReview;
      case 'under_review':
        return OpportunityReviewStatus.underReview;
      case 'approved':
        return OpportunityReviewStatus.approved;
      case 'rejected':
        return OpportunityReviewStatus.rejected;
      case 'taken_down':
        return OpportunityReviewStatus.takenDown;
      default:
        return OpportunityReviewStatus.normal;
    }
  }

  String get value {
    switch (this) {
      case OpportunityReviewStatus.normal:
        return 'normal';
      case OpportunityReviewStatus.pendingReview:
        return 'pending_review';
      case OpportunityReviewStatus.underReview:
        return 'under_review';
      case OpportunityReviewStatus.approved:
        return 'approved';
      case OpportunityReviewStatus.rejected:
        return 'rejected';
      case OpportunityReviewStatus.takenDown:
        return 'taken_down';
    }
  }

  String get label {
    switch (this) {
      case OpportunityReviewStatus.normal:
        return 'Normal';
      case OpportunityReviewStatus.pendingReview:
        return 'Menunggu Review';
      case OpportunityReviewStatus.underReview:
        return 'Sedang Direview';
      case OpportunityReviewStatus.approved:
        return 'Dismissed';
      case OpportunityReviewStatus.rejected:
        return 'Ditolak';
      case OpportunityReviewStatus.takenDown:
        return 'Takedown';
    }
  }
}

class OpportunityReview {
  final String opportunityId;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final String? source;
  final String? contact;
  final String status;
  final int reportCount;
  final int lastReviewedReportCount;
  final int reviewCycle;
  final OpportunityReviewStatus reviewStatus;
  final DateTime? reviewStartedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? reviewNote;
  final DateTime createdAt;
  final DateTime endDate;

  const OpportunityReview({
    required this.opportunityId,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    this.source,
    this.contact,
    required this.status,
    required this.reportCount,
    required this.lastReviewedReportCount,
    required this.reviewCycle,
    required this.reviewStatus,
    this.reviewStartedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.reviewNote,
    required this.createdAt,
    required this.endDate,
  });

  int get newReportCount {
    final count = reportCount - lastReviewedReportCount;
    return count > 0 ? count : 0;
  }

  bool get hasNewReports => newReportCount > 0;

  bool get isTakenDown => reviewStatus == OpportunityReviewStatus.takenDown;

  bool get isDismissed => reviewStatus == OpportunityReviewStatus.approved;

  bool get isActive => status == 'active';
}
