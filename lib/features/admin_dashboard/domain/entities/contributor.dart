class Contributor {
  final String userId;
  final String name;
  final String email;
  final String? username;
  final String? phone;
  final String? avatarUrl;

  final String role;
  final bool isContributor;
  final bool isAdmin;

  final String? regionId;

  final DateTime createdAt;

  const Contributor({
    required this.userId,
    required this.name,
    required this.email,
    this.username,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.isContributor,
    required this.isAdmin,
    this.regionId,
    required this.createdAt,
  });
}
