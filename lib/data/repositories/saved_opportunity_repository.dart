import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/opportunity.dart';

class SavedOpportunityRepository {
  final SupabaseClient _supabase;

  SavedOpportunityRepository(this._supabase);

  // Mengambil ID seluruh peluang yang disimpan pengguna.
  Future<Set<String>> getSavedOpportunityIds(String userId) async {
    final response = await _supabase
        .from('saved_opportunities')
        .select('opportunity_id')
        .eq('user_id', userId);

    return response.map((item) => item['opportunity_id'].toString()).toSet();
  }

  // Mengambil seluruh detail peluang yang disimpan pengguna.
  Future<List<Opportunity>> getSavedOpportunities(String userId) async {
    final response = await _supabase
        .from('saved_opportunities')
        .select('''
          opportunity_id,
          opportunities!saved_opportunities_opportunity_id_fkey(
            *,
            regions(province, city)
          )
        ''')
        .eq('user_id', userId)
        .order('saved_at', ascending: false);

    return response.where((item) => item['opportunities'] != null).map((item) {
      final opportunityData = Map<String, dynamic>.from(
        item['opportunities'] as Map,
      );

      return Opportunity.fromMap(opportunityData);
    }).toList();
  }

  // Menyimpan peluang.
  Future<void> saveOpportunity({
    required String userId,
    required String opportunityId,
  }) async {
    if (opportunityId.trim().isEmpty) {
      throw ArgumentError('ID peluang tidak boleh kosong.');
    }

    await _supabase.from('saved_opportunities').insert({
      'user_id': userId,
      'opportunity_id': opportunityId,
    });
  }

  // Menghapus peluang dari daftar tersimpan.
  Future<void> removeSavedOpportunity({
    required String userId,
    required String opportunityId,
  }) async {
    await _supabase
        .from('saved_opportunities')
        .delete()
        .eq('user_id', userId)
        .eq('opportunity_id', opportunityId);
  }
}
