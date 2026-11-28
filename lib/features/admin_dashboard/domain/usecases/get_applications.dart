import '../entities/contributor_application.dart';
import '../repositories/contributor_application_repository.dart';

class GetApplications {
  final ContributorApplicationRepository repository;

  const GetApplications(this.repository);

  Future<List<ContributorApplication>> call() {
    return repository.getApplications();
  }
}
