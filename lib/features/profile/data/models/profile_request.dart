class UpdateProfileRequest {
  final String name;
  final String username;
  final String phone;
  final String regionId;

  const UpdateProfileRequest({
    required this.name,
    required this.username,
    required this.phone,
    required this.regionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'phone': phone,
      'region_id': regionId,
    };
  }
}
