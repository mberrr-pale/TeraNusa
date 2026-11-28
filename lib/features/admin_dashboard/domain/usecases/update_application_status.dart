import '../entities/contributor_application.dart';
import '../repositories/contributor_application_repository.dart';

class UpdateApplicationStatus {
  final ContributorApplicationRepository repository;

  const UpdateApplicationStatus(this.repository);

  Future<ContributorApplication> call({
    required String id,
    required ApplicationStatus status,
    String? note,
  }) {
    return repository.updateStatus(id: id, status: status, note: note);
  }
}
