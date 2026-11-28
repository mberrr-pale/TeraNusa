import '../entities/opportunity_review.dart';
import '../repositories/opportunity_review_repository.dart';

class GetOpportunityReviews {
  final OpportunityReviewRepository repository;

  GetOpportunityReviews(this.repository);

  Future<List<OpportunityReview>> call() {
    return repository.getOpportunityReviews();
  }
}
