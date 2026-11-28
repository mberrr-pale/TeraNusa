import 'package:supabase_flutter/supabase_flutter.dart';

class ReportRepository {
  final SupabaseClient _supabase;

  ReportRepository(this._supabase);

  /// Insert laporan peluang.
  Future<void> submitReport({
    required String opportunityId,
    required String reason,
    String? description,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu.');
    }

    try {
      await _supabase.from('reports').insert({
        'opportunity_id': opportunityId,
        'reporter_user_id': user.id,
        'reason': reason,
        'description': description?.trim().isNotEmpty == true
            ? description!.trim()
            : null,
      });
    } on PostgrestException catch (e) {
      // PostgreSQL unique violation.
      if (e.code == '23505') {
        throw Exception('Kamu sudah pernah melaporkan peluang ini.');
      }

      throw Exception(e.message);
    } catch (_) {
      rethrow;
    }
  }
}
