import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/contributor_application_repository.dart';
import '../../domain/repositories/contributor_repository.dart';

import '../../domain/usecases/get_applications.dart';
import '../../domain/usecases/update_application_status.dart';
import '../../domain/usecases/get_contributors.dart';

import '../../data/datasources/contributor_application_remote_datasource.dart';
import '../../data/datasources/contributor_remote_datasource.dart';

import '../../data/repositories/contributor_application_repository_impl.dart';
import '../../data/repositories/contributor_repository_impl.dart';

import '../controllers/admin_dashboard_controller.dart';

import '../../domain/repositories/opportunity_review_repository.dart';

import '../../domain/usecases/get_opportunity_reviews.dart';
import '../../domain/usecases/get_opportunity_reports.dart';
import '../../domain/usecases/start_opportunity_review.dart';
import '../../domain/usecases/submit_opportunity_review.dart';
import '../../domain/usecases/update_report_status.dart';

import '../../data/datasources/opportunity_review_remote_datasource.dart';
import '../../data/repositories/opportunity_review_repository_impl.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// APPLICATION

final contributorApplicationRemoteDataSourceProvider =
    Provider<ContributorApplicationRemoteDataSource>((ref) {
      return ContributorApplicationRemoteDataSourceImpl(
        ref.read(supabaseClientProvider),
      );
    });

final contributorApplicationRepositoryProvider =
    Provider<ContributorApplicationRepository>((ref) {
      return ContributorApplicationRepositoryImpl(
        ref.read(contributorApplicationRemoteDataSourceProvider),
      );
    });

final getApplicationsProvider = Provider<GetApplications>((ref) {
  return GetApplications(ref.read(contributorApplicationRepositoryProvider));
});

final updateApplicationStatusProvider = Provider<UpdateApplicationStatus>((
  ref,
) {
  return UpdateApplicationStatus(
    ref.read(contributorApplicationRepositoryProvider),
  );
});

// CONTRIBUTOR / KANDIDAT ADMIN WILAYAH

final contributorRemoteDataSourceProvider =
    Provider<ContributorRemoteDataSource>((ref) {
      return ContributorRemoteDataSourceImpl(ref.read(supabaseClientProvider));
    });

final contributorRepositoryProvider = Provider<ContributorRepository>((ref) {
  return ContributorRepositoryImpl(
    ref.read(contributorRemoteDataSourceProvider),
  );
});

final getContributorsProvider = Provider<GetContributors>((ref) {
  return GetContributors(ref.read(contributorRepositoryProvider));
});

// ADMIN DASHBOARD CONTROLLER

final adminDashboardControllerProvider =
    Provider.autoDispose<AdminDashboardController>((ref) {
      final controller = AdminDashboardController(
        getApplications: ref.read(getApplicationsProvider),
        updateApplicationStatus: ref.read(updateApplicationStatusProvider),
        getContributors: ref.read(getContributorsProvider),
        contributorRepository: ref.read(contributorRepositoryProvider),

        // Opportunity review
        getOpportunityReviews: ref.read(getOpportunityReviewsProvider),
        getOpportunityReports: ref.read(getOpportunityReportsProvider),
        startOpportunityReview: ref.read(startOpportunityReviewProvider),
        submitOpportunityReview: ref.read(submitOpportunityReviewProvider),
        updateReportStatus: ref.read(updateReportStatusProvider),
      );

      ref.onDispose(controller.dispose);

      return controller;
    });
// OPPORTUNITY REVIEW

final opportunityReviewRemoteDataSourceProvider =
    Provider<OpportunityReviewRemoteDataSource>((ref) {
      return OpportunityReviewRemoteDataSourceImpl(
        ref.read(supabaseClientProvider),
      );
    });

final opportunityReviewRepositoryProvider =
    Provider<OpportunityReviewRepository>((ref) {
      return OpportunityReviewRepositoryImpl(
        ref.read(opportunityReviewRemoteDataSourceProvider),
      );
    });

final getOpportunityReviewsProvider = Provider<GetOpportunityReviews>((ref) {
  return GetOpportunityReviews(ref.read(opportunityReviewRepositoryProvider));
});

final getOpportunityReportsProvider = Provider<GetOpportunityReports>((ref) {
  return GetOpportunityReports(ref.read(opportunityReviewRepositoryProvider));
});

final startOpportunityReviewProvider = Provider<StartOpportunityReview>((ref) {
  return StartOpportunityReview(ref.read(opportunityReviewRepositoryProvider));
});

final submitOpportunityReviewProvider = Provider<SubmitOpportunityReview>((
  ref,
) {
  return SubmitOpportunityReview(ref.read(opportunityReviewRepositoryProvider));
});

final updateReportStatusProvider = Provider<UpdateReportStatus>((ref) {
  return UpdateReportStatus(ref.read(opportunityReviewRepositoryProvider));
});
