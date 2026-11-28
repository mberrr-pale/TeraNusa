import '../../domain/entities/opportunity_report.dart';

class OpportunityReportModel {
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

  const OpportunityReportModel({
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

  factory OpportunityReportModel.fromJson(Map<String, dynamic> json) {
    return OpportunityReportModel(
      reportId: json['report_id'] as String,
      opportunityId: json['opportunity_id'] as String,
      reporterUserId: json['reporter_user_id'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String?,
      status: ReportStatus.fromString(json['status'] as String),
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
      adminNote: json['admin_note'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      profiles: json['profiles'] != null
          ? Map<String, dynamic>.from(json['profiles'])
          : <String, dynamic>{},
    );
  }

  OpportunityReport toEntity() {
    return OpportunityReport(
      reportId: reportId,
      opportunityId: opportunityId,
      reporterUserId: reporterUserId,
      reason: reason,
      description: description,
      status: status,
      reviewedBy: reviewedBy,
      reviewedAt: reviewedAt,
      adminNote: adminNote,
      createdAt: createdAt,
      profiles: profiles,
    );
  }
}
