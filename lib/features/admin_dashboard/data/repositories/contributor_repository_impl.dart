import '../../domain/entities/contributor.dart';
import '../../domain/repositories/contributor_repository.dart';
import '../datasources/contributor_remote_datasource.dart';

class ContributorRepositoryImpl implements ContributorRepository {
  final ContributorRemoteDataSource remoteDataSource;

  ContributorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Contributor>> getContributors() async {
    final result = await remoteDataSource.getContributors();

    final contributors = result.map((item) {
      return Contributor(
        userId: item.userId,
        name: item.name,
        email: item.email,
        phone: item.phone,
        avatarUrl: item.avatarUrl,
        regionId: item.regionId,
        role: item.role,
        isContributor: item.isContributor,
        isAdmin: item.isAdmin,
        createdAt: item.createdAt,
      );
    }).toList();

    return contributors;
  }

  @override
  Future<void> promoteToRegionalAdmin({required String userId}) async {
    await remoteDataSource.promoteToRegionalAdmin(userId: userId);
  }
}
