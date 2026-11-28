import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/contributor.dart';
import 'contributor_provider.dart';

final contributorListProvider =
    AsyncNotifierProvider<ContributorListController, List<Contributor>>(
      ContributorListController.new,
    );

class ContributorListController extends AsyncNotifier<List<Contributor>> {
  @override
  Future<List<Contributor>> build() async {
    return _repository.getContributors();
  }

  dynamic get _repository => ref.read(contributorRepositoryProvider);

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getContributors());
  }

  Future<void> promoteToRegionalAdmin(String userId) async {
    await _repository.promoteToRegionalAdmin(userId: userId);

    await refresh();
  }
}
