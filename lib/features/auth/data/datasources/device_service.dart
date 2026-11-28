import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceService {
  final FirebaseMessaging messaging;
  final DeviceInfoPlugin deviceInfo;

  DeviceService({FirebaseMessaging? messaging, DeviceInfoPlugin? deviceInfo})
    : messaging = messaging ?? FirebaseMessaging.instance,
      deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  // GET FCM TOKEN
  Future<String?> getFcmToken() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await messaging.requestPermission();
    }

    if (kIsWeb) {
      // Web membutuhkan VAPID key.
      return null;
    }

    return messaging.getToken();
  }

  // GET DEVICE TYPE
  Future<String> getDeviceType() async {
    if (kIsWeb) return 'web';

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';

      case TargetPlatform.iOS:
        return 'ios';

      default:
        throw UnsupportedError('Platform tidak didukung');
    }
  }

  // GET DEVICE NAME
  Future<String?> getDeviceName() async {
    if (kIsWeb) {
      final info = await deviceInfo.webBrowserInfo;
      return info.browserName.name;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final info = await deviceInfo.androidInfo;
        return '${info.brand} ${info.model}';

      case TargetPlatform.iOS:
        final info = await deviceInfo.iosInfo;
        return info.name;

      default:
        return null;
    }
  }

  // GET DEVICE INFORMATION
  Future<Map<String, String?>> getDeviceInformation() async {
    return {
      'fcmToken': await getFcmToken(),
      'deviceType': await getDeviceType(),
      'deviceName': await getDeviceName(),
    };
  }
}
