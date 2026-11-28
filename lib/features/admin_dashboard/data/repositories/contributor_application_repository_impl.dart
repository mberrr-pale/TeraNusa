import '../../domain/entities/contributor_application.dart';
import '../../domain/repositories/contributor_application_repository.dart';
import '../datasources/contributor_application_remote_datasource.dart';

class ContributorApplicationRepositoryImpl
    implements ContributorApplicationRepository {
  final ContributorApplicationRemoteDataSource dataSource;

  const ContributorApplicationRepositoryImpl(this.dataSource);

  @override
  Future<List<ContributorApplication>> getApplications() {
    return dataSource.getApplications();
  }

  @override
  Future<ContributorApplication> updateStatus({
    required String id,
    required ApplicationStatus status,
    String? note,
  }) {
    return dataSource.updateStatus(id: id, status: status.name, note: note);
  }
}
