import '../entities/opportunity_report.dart';
import '../repositories/opportunity_review_repository.dart';

class GetOpportunityReports {
  final OpportunityReviewRepository repository;

  GetOpportunityReports(this.repository);

  Future<List<OpportunityReport>> call(String opportunityId) {
    return repository.getOpportunityReports(opportunityId);
  }
}
