import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/contributor_application_model.dart';

abstract class ContributorApplicationRemoteDataSource {
  Future<List<ContributorApplicationModel>> getApplications();

  Future<ContributorApplicationModel> updateStatus({
    required String id,
    required String status,
    String? note,
  });
}

class ContributorApplicationRemoteDataSourceImpl
    implements ContributorApplicationRemoteDataSource {
  final SupabaseClient client;

  static const String table = 'contributor_applications';

  ContributorApplicationRemoteDataSourceImpl(this.client);

  @override
  Future<List<ContributorApplicationModel>> getApplications() async {
    final response = await client
        .from(table)
        .select('''
        *,
        profiles!contributor_applications_user_id_fkey (
          name,
          email,
          phone,
          role
        ),
        regions!contributor_applications_region_id_fkey (
          province,
          city,
          district,
          village
        )
      ''')
        .eq('status', 'pending')
        .order('submitted_at', ascending: false);

    return response
        .map(
          (json) => ContributorApplicationModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  @override
  Future<ContributorApplicationModel> updateStatus({
    required String id,
    required String status,
    String? note,
  }) async {
    final response = await client.rpc(
      'review_contributor_application',
      params: {
        'p_application_id': id,
        'p_approved': status == 'approved',
        'p_rejection_reason': note?.trim().isEmpty == true
            ? null
            : note?.trim(),
      },
    );

    if (response == null) {
      throw Exception('Review tidak mengembalikan data');
    }

    return ContributorApplicationModel.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }
}
