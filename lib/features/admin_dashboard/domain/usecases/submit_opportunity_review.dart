import '../entities/opportunity_review.dart';
import '../repositories/opportunity_review_repository.dart';

class SubmitOpportunityReview {
  final OpportunityReviewRepository repository;

  SubmitOpportunityReview(this.repository);

  Future<void> call({
    required String opportunityId,
    required OpportunityReviewStatus status,
    required String note,
  }) {
    return repository.submitOpportunityReview(
      opportunityId: opportunityId,
      status: status,
      note: note,
    );
  }
}
