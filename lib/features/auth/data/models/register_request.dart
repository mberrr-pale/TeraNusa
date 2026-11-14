class RegisterRequest {
  final String name;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String regionId;

  const RegisterRequest({
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.regionId,
  });

  Map<String, dynamic> toMetadata() {
    return {
      'name': name,
      'username': username,
      'role': 'user',
      'phone': phone,
      'region_id': regionId,
    };
  }
}
