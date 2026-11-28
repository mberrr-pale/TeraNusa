import '../entities/contributor.dart';
import '../repositories/contributor_repository.dart';

class GetContributors {
  final ContributorRepository repository;

  const GetContributors(this.repository);

  Future<List<Contributor>> call() {
    return repository.getContributors();
  }
}
