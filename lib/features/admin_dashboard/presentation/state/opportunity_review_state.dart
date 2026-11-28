import '../../domain/entities/opportunity_review.dart';

class OpportunityReviewState {
  final List<OpportunityReview> opportunities;
  final bool isLoading;
  final bool isReviewing;
  final String? errorMessage;

  const OpportunityReviewState({
    this.opportunities = const [],
    this.isLoading = false,
    this.isReviewing = false,
    this.errorMessage,
  });

  int get pendingCount {
    return opportunities
        .where(
          (item) => item.reviewStatus == OpportunityReviewStatus.pendingReview,
        )
        .length;
  }

  int get underReviewCount {
    return opportunities
        .where(
          (item) => item.reviewStatus == OpportunityReviewStatus.underReview,
        )
        .length;
  }

  int get totalReportCount {
    return opportunities.fold<int>(
      0,
      (total, item) => total + item.newReportCount,
    );
  }

  OpportunityReviewState copyWith({
    List<OpportunityReview>? opportunities,
    bool? isLoading,
    bool? isReviewing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OpportunityReviewState(
      opportunities: opportunities ?? this.opportunities,
      isLoading: isLoading ?? this.isLoading,
      isReviewing: isReviewing ?? this.isReviewing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
