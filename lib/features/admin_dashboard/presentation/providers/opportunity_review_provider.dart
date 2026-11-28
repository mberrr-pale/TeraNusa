import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/opportunity_review_remote_datasource.dart';
import '../../data/repositories/opportunity_review_repository_impl.dart';
import '../../domain/repositories/opportunity_review_repository.dart';

import '../../domain/usecases/get_opportunity_reviews.dart';
import '../../domain/usecases/get_opportunity_reports.dart';
import '../../domain/usecases/start_opportunity_review.dart';
import '../../domain/usecases/submit_opportunity_review.dart';
import '../../domain/usecases/update_report_status.dart';

import '../controllers/opportunity_review_controller.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

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

final opportunityReviewControllerProvider =
    Provider<OpportunityReviewController>((ref) {
      final controller = OpportunityReviewController(
        getOpportunityReviews: ref.read(getOpportunityReviewsProvider),
        getOpportunityReports: ref.read(getOpportunityReportsProvider),
        startOpportunityReview: ref.read(startOpportunityReviewProvider),
        submitOpportunityReview: ref.read(submitOpportunityReviewProvider),
        updateReportStatus: ref.read(updateReportStatusProvider),
      );

      ref.onDispose(controller.dispose);

      return controller;
    });
