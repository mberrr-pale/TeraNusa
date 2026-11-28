import '../../domain/entities/contributor_application.dart';

class ContributorApplicationModel extends ContributorApplication {
  const ContributorApplicationModel({
    required super.id,
    required super.fullName,
    required super.roleLabel,
    required super.category,
    required super.position,
    required super.institution,
    required super.email,
    required super.phone,
    required super.region,
    required super.reason,
    required super.submittedAt,
    super.status,
    super.adminNote,
    super.reviewedAt,
  });

  factory ContributorApplicationModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>? ?? {};
    final regionData = json['regions'] as Map<String, dynamic>? ?? {};

    final region =
        [
              regionData['village'],
              regionData['district'],
              regionData['city'],
              regionData['province'],
            ]
            .where(
              (value) => value != null && value.toString().trim().isNotEmpty,
            )
            .join(', ');

    final submittedAt = json['submitted_at'];

    return ContributorApplicationModel(
      id: json['application_id']?.toString() ?? '',

      fullName: profile['name']?.toString() ?? '-',
      email: profile['email']?.toString() ?? '-',
      phone: profile['phone']?.toString() ?? '',

      roleLabel: profile['role']?.toString() ?? 'user',

      category: ApplicationCategory.contributor,
      position: '',
      institution: '',

      region: region.isEmpty ? '-' : region,

      reason: json['message']?.toString() ?? '',

      submittedAt: submittedAt != null
          ? DateTime.parse(submittedAt.toString()).toLocal()
          : DateTime.now(),

      status: ApplicationStatus.fromValue(
        json['status']?.toString() ?? 'pending',
      ),

      adminNote: json['rejection_reason']?.toString(),

      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'].toString()).toLocal(),
    );
  }

  factory ContributorApplicationModel.fromEntity(
    ContributorApplication entity,
  ) {
    return ContributorApplicationModel(
      id: entity.id,
      fullName: entity.fullName,
      roleLabel: entity.roleLabel,
      category: entity.category,
      position: entity.position,
      institution: entity.institution,
      email: entity.email,
      phone: entity.phone,
      region: entity.region,
      reason: entity.reason,
      submittedAt: entity.submittedAt,
      status: entity.status,
      adminNote: entity.adminNote,
      reviewedAt: entity.reviewedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_id': id,
      'message': reason,
      'status': status.name,
      'rejection_reason': adminNote,
      'submitted_at': submittedAt.toUtc().toIso8601String(),
      'reviewed_at': reviewedAt?.toUtc().toIso8601String(),
    };
  }
}
