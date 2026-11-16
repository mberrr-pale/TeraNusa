class Opportunity {
  final String? opportunityId;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String regionId;
  final DateTime endDate;
  final String? source;
  final String? contact;
  final String? imageUrl;
  final String status;
  final DateTime? createdAt;
  final String? regionName;
  final String? regionCity;
  final String? regionProvince;

  const Opportunity({
    this.opportunityId,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.regionId,
    required this.endDate,
    this.source,
    this.contact,
    this.imageUrl,
    this.status = 'active',
    this.createdAt,
    this.regionName,
    this.regionCity,
    this.regionProvince,
  });

  factory Opportunity.fromMap(Map<String, dynamic> map) {
    final regionData = map['regions'];
    final region = regionData is Map
        ? Map<String, dynamic>.from(regionData)
        : null;

    final city = region?['city']?.toString() ?? '';
    final province = region?['province']?.toString() ?? '';

    final regionName = [
      city,
      province,
    ].where((value) => value.isNotEmpty).join(', ');

    return Opportunity(
      opportunityId: map['opportunity_id']?.toString(),
      userId: map['user_id'].toString(),
      title: map['title'].toString(),
      description: map['description'].toString(),
      category: map['category'].toString(),
      regionId: map['region_id'].toString(),
      endDate: DateTime.parse(map['end_date'].toString()),
      source: map['source']?.toString(),
      contact: map['contact']?.toString(),
      imageUrl: map['image_url']?.toString(),
      status: map['status']?.toString() ?? 'active',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      regionName: regionName.isEmpty ? null : regionName,
      regionCity: city.isEmpty ? null : city,
      regionProvince: province.isEmpty ? null : province,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'opportunity_id': opportunityId,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'region_id': regionId,
      'end_date': endDate.toIso8601String(),
      'source': source,
      'contact': contact,
      'image_url': imageUrl,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}