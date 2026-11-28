import 'package:supabase_flutter/supabase_flutter.dart';

class ContributorRequestRemoteDataSource {
  final SupabaseClient client;

  ContributorRequestRemoteDataSource(this.client);

  // ================= SUBMIT =================

  Future<String> submitApplication() async {
    final result = await client.rpc('submit_contributor_application');

    if (result == null) {
      throw Exception('RPC tidak mengembalikan ID pengajuan.');
    }

    return result.toString();
  }

  // ================= GET MY APPLICATION =================

  Future<Map<String, dynamic>?> getMyApplication() async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    return await client
        .from('contributor_applications')
        .select()
        .eq('user_id', userId)
        .order('submitted_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  // ================= WATCH MY APPLICATION =================

  Stream<List<Map<String, dynamic>>> watchMyApplication() {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    return client
        .from('contributor_applications')
        .stream(primaryKey: ['application_id'])
        .eq('user_id', userId)
        .order('submitted_at', ascending: false);
  }
}
