import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'notification_navigation_service.dart';
import 'notification_history_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'admin_notifications',
    'Admin Notifications',
    description: 'Notifikasi aktivitas dan review admin',
    importance: Importance.max,
    playSound: true,
  );

  String? _currentToken;
  bool _initialized = false;

  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  StreamSubscription<AuthState>? _authSubscription;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _initializeLocalNotifications();

      final permission = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('Notification permission: ${permission.authorizationStatus}');

      _foregroundSubscription = FirebaseMessaging.onMessage.listen(
        handleForegroundMessage,
        onError: (error) {
          debugPrint('Foreground notification error: $error');
        },
      );

      _openedSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
        handleNotificationClick,
      );

      _tokenSubscription = _messaging.onTokenRefresh.listen((token) async {
        _currentToken = token;
        await registerDevice(token);
      });

      _authSubscription = _supabase.auth.onAuthStateChange.listen((
        event,
      ) async {
        if (event.session == null) {
          await unregisterCurrentDevice();
        } else {
          await registerCurrentDevice();
        }
      });

      final initialMessage = await _messaging.getInitialMessage();

      if (initialMessage != null) {
        await handleNotificationClick(initialMessage);
      }

      if (_supabase.auth.currentUser != null &&
          permission.authorizationStatus != AuthorizationStatus.denied) {
        await registerCurrentDevice();
      }

      _initialized = true;
      debugPrint('Notification service initialized');
    } catch (e, stackTrace) {
      debugPrint('Notification initialization error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;

        try {
          final decoded = jsonDecode(payload);

          if (decoded is Map) {
            final data = Map<String, dynamic>.from(decoded);
            await _handleLocalNotificationClick(data);
          }
        } catch (e) {
          debugPrint('Notification payload error: $e');
        }
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    debugPrint('========== FCM FOREGROUND ==========');
    debugPrint('Message ID: ${message.messageId}');
    debugPrint('Data: ${message.data}');

    await _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final data = message.data;

    final title =
        data['title']?.toString() ??
        message.notification?.title ??
        'Notifikasi';

    final body =
        data['body']?.toString() ??
        message.notification?.body ??
        'Kamu memiliki notifikasi baru.';

    const androidDetails = AndroidNotificationDetails(
      'admin_notifications',
      'Admin Notifications',
      channelDescription: 'Notifikasi aktivitas dan review admin',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    await _localNotifications.show(
      id:
          message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: jsonEncode(data),
    );
  }

  Future<void> handleNotificationClick(RemoteMessage message) async {
    await _handleLocalNotificationClick(message.data);
  }

  Future<void> _handleLocalNotificationClick(Map<String, dynamic> data) async {
    final notificationId = data['notification_id']?.toString();

    if (notificationId == null || notificationId.isEmpty) return;

    try {
      final notifications = await NotificationHistoryService.instance
          .getNotifications();

      final notification = notifications.where(
        (item) => item['id'].toString() == notificationId,
      );

      if (notification.isEmpty) return;

      final item = notification.first;

      if (item['is_read'] == true) return;

      final rawPayload = item['payload'];
      final payload = rawPayload is Map
          ? Map<String, dynamic>.from(rawPayload)
          : <String, dynamic>{};

      if (!NotificationNavigationService.canNavigate(payload)) return;

      await NotificationHistoryService.instance.markAsRead(notificationId);

      NotificationNavigationService.navigateFromNotification(payload);
    } catch (e) {
      debugPrint('Notification click error: $e');
    }
  }

  Future<void> registerCurrentDevice() async {
    if (_supabase.auth.currentUser == null) return;

    try {
      final token = await _messaging.getToken();

      if (token != null) {
        _currentToken = token;
        await registerDevice(token);
      }
    } catch (e) {
      debugPrint('Get FCM token error: $e');
    }
  }

  Future<void> registerDevice(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final now = DateTime.now().toUtc().toIso8601String();

      await _supabase.from('user_devices').upsert({
        'user_id': user.id,
        'fcm_token': token,
        'device_type': defaultTargetPlatform == TargetPlatform.android
            ? 'android'
            : defaultTargetPlatform == TargetPlatform.iOS
            ? 'ios'
            : 'other',
        'is_active': true,
        'last_seen_at': now,
        'updated_at': now,
      }, onConflict: 'fcm_token');

      debugPrint('Device registered successfully');
    } catch (e) {
      debugPrint('Device registration error: $e');
    }
  }

  Future<void> unregisterCurrentDevice() async {
    final token = _currentToken;
    if (token == null) return;

    try {
      await _supabase
          .from('user_devices')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('fcm_token', token);

      _currentToken = null;
      debugPrint('Device unregistered successfully');
    } catch (e) {
      debugPrint('Device unregister error: $e');
    }
  }

  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _openedSubscription?.cancel();
    await _authSubscription?.cancel();

    _initialized = false;
  }
}
