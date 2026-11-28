import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_applications.dart';
import '../../domain/usecases/update_application_status.dart';

import 'contributor_application_repository_provider.dart';

final getApplicationsProvider = Provider<GetApplications>((ref) {
  final repository = ref.read(contributorApplicationRepositoryProvider);

  return GetApplications(repository);
});

final updateApplicationStatusProvider = Provider<UpdateApplicationStatus>((
  ref,
) {
  final repository = ref.read(contributorApplicationRepositoryProvider);

  return UpdateApplicationStatus(repository);
});
