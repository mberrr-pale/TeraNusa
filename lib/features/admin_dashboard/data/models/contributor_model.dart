class ContributorModel {
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final String? regionId;
  final String role;
  final String? avatarUrl;
  final bool isContributor;
  final bool isAdmin;
  final DateTime createdAt;

  const ContributorModel({
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.regionId,
    required this.role,
    this.avatarUrl,
    required this.isContributor,
    required this.isAdmin,
    required this.createdAt,
  });

  factory ContributorModel.fromJson(Map<String, dynamic> json) {
    return ContributorModel(
      userId: json['user_id'].toString(),
      name: json['name']?.toString() ?? '-',
      email: json['email']?.toString() ?? '-',
      phone: json['phone']?.toString(),
      regionId: json['region_id']?.toString(),
      role: json['role']?.toString() ?? 'user',
      avatarUrl: json['avatar_url']?.toString(),
      isContributor: json['is_contributor'] == true,
      isAdmin: json['is_admin'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString()).toLocal()
          : DateTime.now(),
    );
  }
}
