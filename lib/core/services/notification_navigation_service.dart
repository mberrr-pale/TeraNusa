import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationNavigationService {
  NotificationNavigationService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static GoRouter? _router;
  static Map<String, dynamic>? _pendingNavigation;
  static bool _isNavigating = false;

  static void initialize(GoRouter router) {
    _router = router;

    final pending = _pendingNavigation;

    if (pending != null) {
      _pendingNavigation = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateFromNotification(pending);
      });
    }
  }

  static bool _hasValue(dynamic value) {
    return value != null && value.toString().trim().isNotEmpty;
  }

  // Notifikasi yang hanya bersifat informasi.
  static bool isInformational(Map<String, dynamic> payload) {
    final type = payload['event_type']?.toString();
    final screen = payload['screen']?.toString();

    return type == 'contributor_approved' ||
        type == 'contributor_rejected' ||
        screen == 'contributor_application_detail';
  }

  // Validasi payload sebelum navigasi.
  static bool canNavigate(Map<String, dynamic> payload) {
    final screen = payload['screen']?.toString();
    final type = payload['type']?.toString();

    // Review opportunity.
    if (type == 'opportunity_report_threshold') {
      return _hasValue(payload['opportunity_id']);
    }

    switch (screen) {
      case 'admin_dashboard':
        return true;

      case 'contributor_detail':
        return payload['reference_type'] == 'contributor_application' &&
            _hasValue(payload['reference_id']) &&
            _hasValue(payload['applicant_id']) &&
            _hasValue(payload['region_id']);

      case 'contributor_request':
        return _hasValue(payload['region_id']);

      default:
        return false;
    }
  }

  static void navigateFromNotification(
    Map<String, dynamic> payload, {
    bool fromHistory = false,
  }) {
    if (isInformational(payload)) {
      debugPrint('[NOTIFICATION] Informational notification.');
      return;
    }

    if (!canNavigate(payload)) {
      debugPrint('[NOTIFICATION] Invalid payload: $payload');
      return;
    }

    final router = _router;

    if (router == null) {
      _pendingNavigation = payload;
      return;
    }

    if (_isNavigating) return;

    _isNavigating = true;

    try {
      final type = payload['type']?.toString();

      // Opportunity review detail.
      if (type == 'opportunity_report_threshold') {
        final opportunityId = payload['opportunity_id'].toString();

        router.pushNamed(
          'opportunityReviewDetail',
          pathParameters: {'opportunityId': opportunityId},
        );

        return;
      }

      // Navigasi notifikasi admin lainnya.
      final screen = payload['screen']?.toString();

      final extra = <String, dynamic>{
        'focusSection': switch (screen) {
          'contributor_request' || 'contributor_detail' => 'contributor',
          'admin_dashboard' => payload['focus_section'],
          _ => null,
        },
      };

      if (fromHistory) {
        router.pushNamed('adminDashboard', extra: extra);
      } else {
        router.goNamed('adminDashboard', extra: extra);
      }
    } catch (e, stackTrace) {
      debugPrint('[NOTIFICATION] Navigation error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isNavigating = false;
    }
  }
}
