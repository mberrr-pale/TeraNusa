import '../../domain/entities/opportunity_review.dart';

class OpportunityReviewModel {
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

  const OpportunityReviewModel({
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

  factory OpportunityReviewModel.fromJson(Map<String, dynamic> json) {
    return OpportunityReviewModel(
      opportunityId: json['opportunity_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'].toString(),
      imageUrl: json['image_url'] as String?,
      source: json['source'] as String?,
      contact: json['contact'] as String?,
      status: json['status'].toString(),
      reportCount: (json['report_count'] as num).toInt(),
      lastReviewedReportCount: (json['last_reviewed_report_count'] as num)
          .toInt(),
      reviewCycle: (json['review_cycle'] as num).toInt(),
      reviewStatus: OpportunityReviewStatus.fromString(
        json['review_status'] as String,
      ),
      reviewStartedAt: json['review_started_at'] != null
          ? DateTime.parse(json['review_started_at'])
          : null,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
      reviewedBy: json['reviewed_by'] as String?,
      reviewNote: json['review_note'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      endDate: DateTime.parse(json['end_date']),
    );
  }

  OpportunityReview toEntity() {
    return OpportunityReview(
      opportunityId: opportunityId,
      title: title,
      description: description,
      category: category,
      imageUrl: imageUrl,
      source: source,
      contact: contact,
      status: status,
      reportCount: reportCount,
      lastReviewedReportCount: lastReviewedReportCount,
      reviewCycle: reviewCycle,
      reviewStatus: reviewStatus,
      reviewStartedAt: reviewStartedAt,
      reviewedAt: reviewedAt,
      reviewedBy: reviewedBy,
      reviewNote: reviewNote,
      createdAt: createdAt,
      endDate: endDate,
    );
  }
}
