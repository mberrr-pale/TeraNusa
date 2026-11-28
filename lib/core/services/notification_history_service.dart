import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationHistoryService {
  NotificationHistoryService._();

  static final NotificationHistoryService instance =
      NotificationHistoryService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  // Mengambil seluruh histori notifikasi
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final userId = _userId;

    if (userId == null) return [];

    final response = await _supabase
        .from('notifications')
        .select()
        .eq('recipient_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Menghitung notifikasi belum dibaca
  Future<int> getUnreadCount() async {
    final userId = _userId;

    if (userId == null) return 0;

    final response = await _supabase
        .from('notifications')
        .select('id')
        .eq('recipient_id', userId)
        .eq('is_read', false);

    return response.length;
  }

  // Menandai notifikasi sudah dibaca
  Future<void> markAsRead(String notificationId) async {
    final userId = _userId;

    if (userId == null) return;

    await _supabase
        .from('notifications')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', notificationId)
        .eq('recipient_id', userId)
        .eq('is_read', false);
  }

  // Stream realtime histori notifikasi
  Stream<List<Map<String, dynamic>>> watchNotifications() {
    final userId = _userId;

    if (userId == null) {
      return Stream.value([]);
    }

    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('recipient_id', userId)
        .order('created_at', ascending: false)
        .map(
          (rows) => rows.map((row) => Map<String, dynamic>.from(row)).toList(),
        );
  }

  // Stream jumlah notifikasi belum dibaca
  Stream<int> watchUnreadCount() {
    return watchNotifications().map(
      (notifications) =>
          notifications.where((item) => item['is_read'] == false).length,
    );
  }
}
