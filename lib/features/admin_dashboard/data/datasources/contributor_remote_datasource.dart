import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/contributor_model.dart';

abstract class ContributorRemoteDataSource {
  Future<List<ContributorModel>> getContributors();

  Future<void> promoteToRegionalAdmin({required String userId});
}

class ContributorRemoteDataSourceImpl implements ContributorRemoteDataSource {
  final SupabaseClient client;

  ContributorRemoteDataSourceImpl(this.client);

  @override
  Future<List<ContributorModel>> getContributors() async {
    final response = await client.rpc('get_available_contributors');

    return (response as List)
        .map(
          (json) => ContributorModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<void> promoteToRegionalAdmin({required String userId}) async {
    await client.rpc(
      'promote_to_regional_admin',
      params: {'p_user_id': userId},
    );
  }
}
