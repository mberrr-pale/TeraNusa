import '../repositories/opportunity_review_repository.dart';

class StartOpportunityReview {
  final OpportunityReviewRepository repository;

  StartOpportunityReview(this.repository);

  Future<void> call(String opportunityId) {
    return repository.startOpportunityReview(opportunityId);
  }
}
