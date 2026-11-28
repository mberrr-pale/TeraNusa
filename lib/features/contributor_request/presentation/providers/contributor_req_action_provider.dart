import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contributor_req_provider.dart';

final contributorRequestActionProvider =
    AsyncNotifierProvider<ContributorRequestActionNotifier, void>(
      ContributorRequestActionNotifier.new,
    );

class ContributorRequestActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit(String? message) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(contributorRequestRepositoryProvider);

      await repository.submitApplication(message: message);

      ref.invalidate(myContributorApplicationProvider);
      ref.invalidate(myContributorApplicationStreamProvider);
    });
  }
}
