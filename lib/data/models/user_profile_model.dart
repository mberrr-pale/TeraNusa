class UserProfile {
  final String userId;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String regionId;

  // Foto profil dari Supabase
  final String? avatarUrl;

  // Path foto lokal dari Drift
  final String? avatarLocalPath;

  final bool isContributor;
  final bool isAdmin;

  const UserProfile({
    required this.userId,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.regionId,
    this.avatarUrl,
    this.avatarLocalPath,
    required this.isContributor,
    required this.isAdmin,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      regionId: json['region_id'] ?? '',
      avatarUrl: json['avatar_url'],
      isContributor: json['is_contributor'] ?? false,
      isAdmin: json['is_admin'] ?? false,
    );
  }

  bool get isUser => true;
}
