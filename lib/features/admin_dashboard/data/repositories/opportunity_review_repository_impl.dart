import '../../domain/entities/opportunity_review.dart';
import '../../domain/entities/opportunity_report.dart';
import '../../domain/repositories/opportunity_review_repository.dart';

import '../datasources/opportunity_review_remote_datasource.dart';
import '../models/opportunity_review_model.dart';
import '../models/opportunity_report_model.dart';

class OpportunityReviewRepositoryImpl implements OpportunityReviewRepository {
  final OpportunityReviewRemoteDataSource datasource;

  OpportunityReviewRepositoryImpl(this.datasource);

  @override
  Future<List<OpportunityReview>> getOpportunityReviews() async {
    final response = await datasource.getOpportunityReviews();

    return response
        .map((json) => OpportunityReviewModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<OpportunityReview> getOpportunityReviewDetail(
    String opportunityId,
  ) async {
    final response = await datasource.getOpportunityReviewDetail(opportunityId);

    return OpportunityReviewModel.fromJson(response).toEntity();
  }

  @override
  Future<List<OpportunityReport>> getOpportunityReports(
    String opportunityId,
  ) async {
    final response = await datasource.getOpportunityReports(opportunityId);

    return response
        .map((json) => OpportunityReportModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<void> startOpportunityReview(String opportunityId) {
    return datasource.startOpportunityReview(opportunityId);
  }

  @override
  Future<void> submitOpportunityReview({
    required String opportunityId,
    required OpportunityReviewStatus status,
    required String note,
  }) {
    return datasource.submitOpportunityReview(
      opportunityId: opportunityId,
      status: status.value,
      note: note,
    );
  }

  @override
  Future<void> updateReportStatus({
    required String reportId,
    required ReportStatus status,
    required String adminNote,
  }) {
    return datasource.updateReportStatus(
      reportId: reportId,
      status: status.value,
      adminNote: adminNote,
    );
  }
}
