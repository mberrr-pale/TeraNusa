class RegionModel {
  final String regionId;
  final String province;
  final String city;
  final String district;
  final String village;

  const RegionModel({
    required this.regionId,
    required this.province,
    required this.city,
    required this.district,
    required this.village,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      regionId: json['region_id'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      village: json['village'],
    );
  }

  String get displayName {
    return '$village, $district, $city';
  }
}
