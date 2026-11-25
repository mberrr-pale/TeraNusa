import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/contributor_application_repository.dart';

/// Provider tunggal untuk repository pengajuan kontributor agar state in-memory
/// tidak hilang saat halaman profil dibangun ulang.
// TODO(contributor-review): ganti ke implementasi API/Drift asli bila sudah siap.
final contributorApplicationRepositoryProvider =
    Provider<ContributorApplicationRepository>((ref) {
      return DummyContributorApplicationRepository();
    });
