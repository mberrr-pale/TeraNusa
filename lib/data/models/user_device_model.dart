class UserDevice {
  final String id;
  final String userId;
  final String fcmToken;
  final String deviceType;
  final String? deviceName;
  final bool isActive;
  final DateTime? lastSeenAt;
  final DateTime? createdAt;

  const UserDevice({
    required this.id,
    required this.userId,
    required this.fcmToken,
    required this.deviceType,
    this.deviceName,
    required this.isActive,
    this.lastSeenAt,
    this.createdAt,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fcmToken: json['fcm_token'] as String,
      deviceType: json['device_type'] as String,
      deviceName: json['device_name'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      lastSeenAt: json['last_seen_at'] != null
          ? DateTime.parse(json['last_seen_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
