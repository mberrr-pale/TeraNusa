import '../entities/contributor_application.dart';

abstract class ContributorApplicationRepository {
  Future<List<ContributorApplication>> getApplications();

  Future<ContributorApplication> updateStatus({
    required String id,
    required ApplicationStatus status,
    String? note,
  });
}
