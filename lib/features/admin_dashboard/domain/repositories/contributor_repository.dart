import '../entities/contributor.dart';

abstract class ContributorRepository {
  Future<List<Contributor>> getContributors();

  Future<void> promoteToRegionalAdmin({required String userId});
}
