import '../entities/opportunity_report.dart';
import '../repositories/opportunity_review_repository.dart';

class UpdateReportStatus {
  final OpportunityReviewRepository repository;

  UpdateReportStatus(this.repository);

  Future<void> call({
    required String reportId,
    required ReportStatus status,
    required String adminNote,
  }) {
    return repository.updateReportStatus(
      reportId: reportId,
      status: status,
      adminNote: adminNote,
    );
  }
}
