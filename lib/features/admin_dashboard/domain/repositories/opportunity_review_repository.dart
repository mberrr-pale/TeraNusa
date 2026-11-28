import '../entities/opportunity_review.dart';
import '../entities/opportunity_report.dart';

abstract class OpportunityReviewRepository {
  Future<List<OpportunityReview>> getOpportunityReviews();

  Future<OpportunityReview> getOpportunityReviewDetail(String opportunityId);

  Future<List<OpportunityReport>> getOpportunityReports(String opportunityId);

  Future<void> startOpportunityReview(String opportunityId);

  Future<void> submitOpportunityReview({
    required String opportunityId,
    required OpportunityReviewStatus status,
    required String note,
  });

  Future<void> updateReportStatus({
    required String reportId,
    required ReportStatus status,
    required String adminNote,
  });
}
