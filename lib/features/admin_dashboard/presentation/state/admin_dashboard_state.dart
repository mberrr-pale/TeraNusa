import '../../domain/entities/contributor.dart';
import '../../domain/entities/contributor_application.dart';

import '../../domain/entities/opportunity_review.dart';
import '../../domain/entities/contributor.dart';
import '../../domain/entities/contributor_application.dart';

class AdminDashboardState {
  final List<ContributorApplication> applications;
  final List<Contributor> availableContributors;

  // Opportunity review
  final List<OpportunityReview> opportunityReviews;

  final bool isLoading;
  final bool isLoadingContributors;
  final bool isLoadingOpportunityReviews;
  final bool isReviewing;

  final String? errorMessage;
  final String? contributorErrorMessage;
  final String? opportunityReviewErrorMessage;

  final bool contributorNewestFirst;
  final bool regionalAdminNewestFirst;

  const AdminDashboardState({
    this.applications = const [],
    this.availableContributors = const [],
    this.opportunityReviews = const [],

    this.isLoading = false,
    this.isLoadingContributors = false,
    this.isLoadingOpportunityReviews = false,
    this.isReviewing = false,

    this.errorMessage,
    this.contributorErrorMessage,
    this.opportunityReviewErrorMessage,

    this.contributorNewestFirst = true,
    this.regionalAdminNewestFirst = true,
  });

  int get pendingContributorCount => applications
      .where(
        (item) =>
            item.category == ApplicationCategory.contributor &&
            item.status == ApplicationStatus.pending,
      )
      .length;

  int get pendingRegionalAdminCount => availableContributors.length;

  int get pendingReportCount => opportunityReviews
      .where(
        (item) =>
            item.reviewStatus == OpportunityReviewStatus.pendingReview ||
            item.reviewStatus == OpportunityReviewStatus.underReview,
      )
      .length;

  int get totalOpportunityReportCount =>
      opportunityReviews.fold(0, (total, item) => total + item.newReportCount);

  AdminDashboardState copyWith({
    List<ContributorApplication>? applications,
    List<Contributor>? availableContributors,
    List<OpportunityReview>? opportunityReviews,

    bool? isLoading,
    bool? isLoadingContributors,
    bool? isLoadingOpportunityReviews,
    bool? isReviewing,

    String? errorMessage,
    String? contributorErrorMessage,
    String? opportunityReviewErrorMessage,

    bool clearError = false,
    bool clearContributorError = false,
    bool clearOpportunityReviewError = false,

    bool? contributorNewestFirst,
    bool? regionalAdminNewestFirst,
  }) {
    return AdminDashboardState(
      applications: applications ?? this.applications,
      availableContributors:
          availableContributors ?? this.availableContributors,
      opportunityReviews: opportunityReviews ?? this.opportunityReviews,

      isLoading: isLoading ?? this.isLoading,
      isLoadingContributors:
          isLoadingContributors ?? this.isLoadingContributors,
      isLoadingOpportunityReviews:
          isLoadingOpportunityReviews ?? this.isLoadingOpportunityReviews,
      isReviewing: isReviewing ?? this.isReviewing,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      contributorErrorMessage: clearContributorError
          ? null
          : contributorErrorMessage ?? this.contributorErrorMessage,

      opportunityReviewErrorMessage: clearOpportunityReviewError
          ? null
          : opportunityReviewErrorMessage ?? this.opportunityReviewErrorMessage,

      contributorNewestFirst:
          contributorNewestFirst ?? this.contributorNewestFirst,

      regionalAdminNewestFirst:
          regionalAdminNewestFirst ?? this.regionalAdminNewestFirst,
    );
  }
}
