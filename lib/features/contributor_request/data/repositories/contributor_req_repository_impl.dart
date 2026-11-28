import '../../domain/entities/contributor_request.dart';
import '../../domain/repositories/contributor_req_repository.dart';
import '../datasources/contributor_req_remote_datasource.dart';
import '../models/contributor_req_request_model.dart';

class ContributorRequestRepositoryImpl implements ContributorRequestRepository {
  final ContributorRequestRemoteDataSource remote;

  ContributorRequestRepositoryImpl(this.remote);

  ContributorRequest _map(Map<String, dynamic> json) {
    return ContributorRequestModel.fromJson(json);
  }

  @override
  Future<String> submitApplication({String? message}) {
    return remote.submitApplication();
  }

  @override
  Future<ContributorRequest?> getMyApplication() async {
    final result = await remote.getMyApplication();

    return result == null ? null : _map(result);
  }

  @override
  Stream<List<ContributorRequest>> watchMyApplication() {
    return remote.watchMyApplication().map((rows) => rows.map(_map).toList());
  }
}
