import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:convert';

import '../../../../core/services/notification_history_service.dart';
import '../../../../core/services/notification_navigation_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationHistoryPage extends StatelessWidget {
  const NotificationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifikasi',
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.heading),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: NotificationHistoryService.instance.watchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return _buildError();
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return _buildEmpty();
          }

          final unread = notifications
              .where((item) => item['is_read'] == false)
              .length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    Text(
                      'Semua aktivitas',
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                      ),
                    ),
                    const Spacer(),
                    if (unread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$unread belum dibaca',
                          style: AppTextStyles.secondary.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _NotificationItem(
                      key: ValueKey(notifications[index]['id']),
                      notification: notifications[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Belum ada notifikasi',
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Notifikasi aktivitas kamu akan muncul di sini.',
              textAlign: TextAlign.center,
              style: AppTextStyles.secondary.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 42, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('Gagal memuat notifikasi'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // StreamBuilder akan mencoba kembali ketika halaman
              // dibuka ulang atau koneksi realtime pulih.
            },
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatefulWidget {
  final Map<String, dynamic> notification;

  const _NotificationItem({super.key, required this.notification});

  @override
  State<_NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<_NotificationItem> {
  bool _isProcessing = false;

  Future<void> _openNotification() async {
    final notification = widget.notification;

    if (notification['is_read'] == true || _isProcessing) {
      return;
    }

    // Parse payload.
    final rawPayload = notification['payload'];

    Map<String, dynamic> payload = {};

    try {
      if (rawPayload is Map) {
        payload = Map<String, dynamic>.from(rawPayload);
      } else if (rawPayload is String && rawPayload.isNotEmpty) {
        final decoded = jsonDecode(rawPayload);

        if (decoded is Map) {
          payload = Map<String, dynamic>.from(decoded);
        }
      }
    } catch (e) {
      debugPrint('[NOTIFICATION] Payload parsing error: $e');
    }

    // Sertakan event_type dari tabel notifikasi.
    payload['event_type'] = notification['event_type']?.toString();

    final isInformational = NotificationNavigationService.isInformational(
      payload,
    );

    final canNavigate = NotificationNavigationService.canNavigate(payload);

    if (!isInformational && !canNavigate) {
      debugPrint('[NOTIFICATION] Invalid payload: $payload');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifikasi tidak dapat dibuka.')),
      );

      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Tandai notifikasi sudah dibaca.
      await NotificationHistoryService.instance.markAsRead(
        notification['id'].toString(),
      );

      if (!mounted) return;

      // Notifikasi informasi cukup ditandai selesai.
      if (isInformational) {
        return;
      }

      // Notifikasi yang membutuhkan navigasi.
      NotificationNavigationService.navigateFromNotification(
        payload,
        fromHistory: true,
      );
    } catch (e) {
      debugPrint('[NOTIFICATION] Open error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka notifikasi.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _formatDate(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');

    if (date == null) return '';

    final local = date.toLocal();
    final difference = DateTime.now().difference(local);

    if (difference.isNegative) {
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(local);
    }

    if (difference.inMinutes < 1) return 'Baru saja';

    if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    }

    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(local);
  }

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;

    final isRead = notification['is_read'] == true;

    final title = notification['title']?.toString() ?? 'Notifikasi';

    final body = notification['body']?.toString() ?? '';

    final createdAt = notification['created_at'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isRead ? null : _openNotification,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isRead ? AppColors.white : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isRead
                  ? AppColors.border
                  : AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isRead ? Colors.grey.shade100 : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notifications_active_outlined,
                  size: 23,
                  color: isRead ? Colors.grey : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isRead
                            ? Colors.grey.shade600
                            : AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: AppTextStyles.secondary.copyWith(
                        fontSize: 12,
                        color: isRead ? Colors.grey : AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      _formatDate(createdAt),
                      style: AppTextStyles.secondary.copyWith(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_isProcessing)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (isRead)
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey.shade400,
                  size: 18,
                )
              else
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
