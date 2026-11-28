import 'package:flutter/foundation.dart';

import '../../domain/entities/opportunity_review.dart';
import '../../domain/entities/opportunity_report.dart';

import '../../domain/usecases/get_opportunity_reviews.dart';
import '../../domain/usecases/get_opportunity_reports.dart';
import '../../domain/usecases/start_opportunity_review.dart';
import '../../domain/usecases/submit_opportunity_review.dart';
import '../../domain/usecases/update_report_status.dart';

import '../state/opportunity_review_state.dart';

class OpportunityReviewController extends ChangeNotifier {
  final GetOpportunityReviews getOpportunityReviews;
  final GetOpportunityReports getOpportunityReports;
  final StartOpportunityReview startOpportunityReview;
  final SubmitOpportunityReview submitOpportunityReview;
  final UpdateReportStatus updateReportStatus;

  OpportunityReviewState _state = const OpportunityReviewState();

  OpportunityReviewState get state => _state;

  OpportunityReviewController({
    required this.getOpportunityReviews,
    required this.getOpportunityReports,
    required this.startOpportunityReview,
    required this.submitOpportunityReview,
    required this.updateReportStatus,
  });

  void _setState(OpportunityReviewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadOpportunityReviews() async {
    _setState(_state.copyWith(isLoading: true, clearError: true));

    try {
      final result = await getOpportunityReviews();

      _setState(
        _state.copyWith(
          opportunities: result,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadOpportunityReviews();
  }

  Future<List<OpportunityReport>> loadOpportunityReports(
    String opportunityId,
  ) async {
    return await getOpportunityReports(opportunityId);
  }

  Future<void> startReview(String opportunityId) async {
    try {
      _setState(_state.copyWith(isReviewing: true, clearError: true));

      await startOpportunityReview(opportunityId);

      final result = await getOpportunityReviews();

      _setState(
        _state.copyWith(
          opportunities: result,
          isReviewing: false,
          clearError: true,
        ),
      );
    } catch (e) {
      _setState(
        _state.copyWith(isReviewing: false, errorMessage: e.toString()),
      );

      rethrow;
    }
  }

  Future<void> submitReview({
    required String opportunityId,
    required OpportunityReviewStatus status,
    required String note,
  }) async {
    try {
      await submitOpportunityReview(
        opportunityId: opportunityId,
        status: status,
        note: note,
      );

      await loadOpportunityReviews();
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));

      rethrow;
    }
  }

  Future<void> changeReportStatus({
    required String reportId,
    required ReportStatus status,
    required String adminNote,
  }) async {
    await updateReportStatus(
      reportId: reportId,
      status: status,
      adminNote: adminNote,
    );
  }
}
