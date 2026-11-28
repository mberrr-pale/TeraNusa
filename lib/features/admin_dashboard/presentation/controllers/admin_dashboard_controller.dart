import 'package:flutter/foundation.dart';

import '../../domain/entities/contributor_application.dart';
import '../../domain/usecases/get_applications.dart';
import '../../domain/usecases/update_application_status.dart';
import '../../domain/usecases/get_contributors.dart';
import '../../domain/entities/contributor.dart';
import '../../domain/repositories/contributor_repository.dart';
import '../../domain/entities/opportunity_review.dart';
import '../../domain/entities/opportunity_report.dart';

import '../../domain/usecases/get_opportunity_reviews.dart';
import '../../domain/usecases/get_opportunity_reports.dart';
import '../../domain/usecases/start_opportunity_review.dart';
import '../../domain/usecases/submit_opportunity_review.dart';
import '../../domain/usecases/update_report_status.dart';
import '../state/admin_dashboard_state.dart';

class AdminDashboardController extends ChangeNotifier {
  final GetApplications getApplications;
  final UpdateApplicationStatus updateApplicationStatus;
  final GetContributors getContributors;
  final ContributorRepository contributorRepository;
  final GetOpportunityReviews getOpportunityReviews;
  final GetOpportunityReports getOpportunityReports;
  final StartOpportunityReview startOpportunityReview;
  final SubmitOpportunityReview submitOpportunityReview;
  final UpdateReportStatus updateReportStatus;

  AdminDashboardState _state = const AdminDashboardState();

  AdminDashboardState get state => _state;

  bool _disposed = false;

  AdminDashboardController({
    required this.getApplications,
    required this.updateApplicationStatus,
    required this.getContributors,
    required this.contributorRepository,
    required this.getOpportunityReviews,
    required this.getOpportunityReports,
    required this.startOpportunityReview,
    required this.submitOpportunityReview,
    required this.updateReportStatus,
  });

  void _emit(AdminDashboardState value) {
    if (_disposed) return;

    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadApplications({
    Function(String error, String stackTrace)? onError,
  }) async {
    if (_disposed) return;

    _emit(
      _state.copyWith(
        isLoading: true,
        isLoadingContributors: true,
        clearError: true,
        clearContributorError: true,
      ),
    );

    final results = await Future.wait([
      _loadApplicationData(),
      _loadContributorData(),
      loadOpportunityReviews(),
    ]);

    if (_disposed) return;
  }

  Future<void> _loadApplicationData() async {
    try {
      final result = await getApplications();

      if (_disposed) return;

      _emit(
        _state.copyWith(
          applications: result,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (e) {
      if (_disposed) return;

      _emit(_state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _loadContributorData() async {
    try {
      final result = await getContributors();

      if (_disposed) return;

      _emit(
        _state.copyWith(
          availableContributors: result,
          isLoadingContributors: false,
          clearContributorError: true,
        ),
      );
    } catch (e) {
      if (_disposed) return;

      _emit(
        _state.copyWith(
          isLoadingContributors: false,
          contributorErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadAvailableContributors() async {
    if (_disposed) return;

    _emit(
      _state.copyWith(isLoadingContributors: true, clearContributorError: true),
    );

    try {
      final result = await getContributors();

      if (_disposed) return;

      _emit(
        _state.copyWith(
          availableContributors: result,
          isLoadingContributors: false,
          clearContributorError: true,
        ),
      );
    } catch (error) {
      if (_disposed) return;

      _emit(
        _state.copyWith(
          isLoadingContributors: false,
          contributorErrorMessage: error.toString(),
        ),
      );
    }
  }

  List<Contributor> get regionalAdminCandidates {
    final items = [..._state.availableContributors];

    items.sort(
      (a, b) => _state.regionalAdminNewestFirst
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt),
    );

    return items;
  }

  Future<void> promoteContributor(String userId) async {
    if (_disposed) {
      throw StateError('Controller sudah di-dispose.');
    }

    _emit(_state.copyWith(isReviewing: true));

    try {
      await contributorRepository.promoteToRegionalAdmin(userId: userId);

      if (_disposed) return;

      await loadAvailableContributors();

      if (_disposed) return;

      _emit(_state.copyWith(isReviewing: false, clearContributorError: true));
    } catch (error) {
      if (!_disposed) {
        _emit(
          _state.copyWith(
            isReviewing: false,
            contributorErrorMessage: error.toString(),
          ),
        );
      }

      rethrow;
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      loadApplications(),
      loadAvailableContributors(),
      loadOpportunityReviews(),
    ]);
  }

  void toggleContributorSort() {
    if (_disposed) return;

    _emit(
      _state.copyWith(contributorNewestFirst: !_state.contributorNewestFirst),
    );
  }

  void toggleRegionalAdminSort() {
    if (_disposed) return;

    _emit(
      _state.copyWith(
        regionalAdminNewestFirst: !_state.regionalAdminNewestFirst,
      ),
    );
  }

  List<ContributorApplication> _sort({
    required ApplicationCategory category,
    required bool newestFirst,
  }) {
    final items = _state.applications
        .where((item) => item.category == category)
        .toList();

    items.sort(
      (a, b) => newestFirst
          ? b.submittedAt.compareTo(a.submittedAt)
          : a.submittedAt.compareTo(b.submittedAt),
    );

    return items;
  }

  List<ContributorApplication> get contributorApplications {
    return _sort(
      category: ApplicationCategory.contributor,
      newestFirst: _state.contributorNewestFirst,
    ).where((item) => item.status == ApplicationStatus.pending).toList();
  }

  List<ContributorApplication> get regionalAdminApplications {
    return _sort(
      category: ApplicationCategory.regionalAdmin,
      newestFirst: _state.regionalAdminNewestFirst,
    ).where((item) => item.status == ApplicationStatus.pending).toList();
  }

  Future<ContributorApplication> reviewApplication({
    required String id,
    required ApplicationStatus status,
    String? note,
  }) async {
    if (_disposed) {
      throw StateError('Controller sudah di-dispose.');
    }

    _emit(_state.copyWith(isReviewing: true));

    try {
      final updated = await updateApplicationStatus(
        id: id,
        status: status,
        note: note,
      );

      if (_disposed) return updated;

      final updatedItems = _state.applications.map((item) {
        return item.id == updated.id ? updated : item;
      }).toList();

      _emit(
        _state.copyWith(
          applications: updatedItems,
          isReviewing: false,
          clearError: true,
        ),
      );

      return updated;
    } catch (error) {
      if (!_disposed) {
        _emit(
          _state.copyWith(isReviewing: false, errorMessage: error.toString()),
        );
      }

      rethrow;
    }
  }

  Future<void> loadOpportunityReviews() async {
    if (_disposed) return;

    _emit(
      _state.copyWith(
        isLoadingOpportunityReviews: true,
        clearOpportunityReviewError: true,
      ),
    );

    try {
      final result = await getOpportunityReviews();

      if (_disposed) return;

      _emit(
        _state.copyWith(
          opportunityReviews: result,
          isLoadingOpportunityReviews: false,
          clearOpportunityReviewError: true,
        ),
      );
    } catch (error) {
      if (_disposed) return;

      _emit(
        _state.copyWith(
          isLoadingOpportunityReviews: false,
          opportunityReviewErrorMessage: error.toString(),
        ),
      );
    }
  }

  Future<List<OpportunityReport>> loadOpportunityReports(
    String opportunityId,
  ) async {
    if (_disposed) {
      throw StateError('Controller sudah di-dispose.');
    }

    return getOpportunityReports(opportunityId);
  }

  Future<void> startOpportunityReviewProcess(String opportunityId) async {
    if (_disposed) {
      throw StateError('Controller sudah di-dispose.');
    }

    _emit(_state.copyWith(isReviewing: true));

    try {
      await startOpportunityReview(opportunityId);

      if (_disposed) return;

      await loadOpportunityReviews();

      if (_disposed) return;

      _emit(_state.copyWith(isReviewing: false));
    } catch (error) {
      if (!_disposed) {
        _emit(
          _state.copyWith(
            isReviewing: false,
            opportunityReviewErrorMessage: error.toString(),
          ),
        );
      }

      rethrow;
    }
  }

  Future<void> submitOpportunityReviewProcess({
    required String opportunityId,
    required OpportunityReviewStatus status,
    required String note,
  }) async {
    if (_disposed) {
      throw StateError('Controller sudah di-dispose.');
    }

    _emit(_state.copyWith(isReviewing: true));

    try {
      await submitOpportunityReview(
        opportunityId: opportunityId,
        status: status,
        note: note,
      );

      if (_disposed) return;

      await loadOpportunityReviews();

      if (_disposed) return;

      _emit(_state.copyWith(isReviewing: false));
    } catch (error) {
      if (!_disposed) {
        _emit(
          _state.copyWith(
            isReviewing: false,
            opportunityReviewErrorMessage: error.toString(),
          ),
        );
      }

      rethrow;
    }
  }

  Future<void> changeOpportunityReportStatus({
    required String reportId,
    required ReportStatus status,
    required String adminNote,
  }) async {
    if (_disposed) {
      throw StateError('Controller sudah di-dispose.');
    }

    await updateReportStatus(
      reportId: reportId,
      status: status,
      adminNote: adminNote,
    );
  }
}
