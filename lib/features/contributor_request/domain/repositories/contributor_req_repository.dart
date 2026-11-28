import '../entities/contributor_request.dart';

abstract class ContributorRequestRepository {
  Future<String> submitApplication({String? message});

  Future<ContributorRequest?> getMyApplication();

  Stream<List<ContributorRequest>> watchMyApplication();
}
