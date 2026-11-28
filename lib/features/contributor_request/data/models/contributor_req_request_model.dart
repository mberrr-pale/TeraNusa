import '../../domain/entities/contributor_request.dart';

class ContributorRequestModel extends ContributorRequest {
  const ContributorRequestModel({
    required super.applicationId,
    required super.userId,
    required super.regionId,
    required super.status,
    super.message,
    super.rejectionReason,
    required super.createdAt,
    super.reviewedAt,
    super.applicantName,
    super.applicantEmail,
    super.applicantAvatar,
  });

  static DateTime _parseDate(dynamic value) {
    if (value == null) {
      throw const FormatException('Tanggal pengajuan tidak ditemukan');
    }

    return DateTime.parse(value.toString());
  }

  factory ContributorRequestModel.fromJson(Map<String, dynamic> json) {
    return ContributorRequestModel(
      applicationId: json['application_id'].toString(),
      userId: json['user_id'].toString(),
      regionId: json['region_id'].toString(),
      status: ContributorRequestStatus.fromString(json['status'].toString()),
      message: json['message']?.toString(),
      rejectionReason: json['rejection_reason']?.toString(),
      createdAt: _parseDate(json['submitted_at'] ?? json['created_at']),
      reviewedAt: json['reviewed_at'] == null
          ? null
          : _parseDate(json['reviewed_at']),
      applicantName: json['applicant_name']?.toString(),
      applicantEmail: json['applicant_email']?.toString(),
      applicantAvatar: json['applicant_avatar']?.toString(),
    );
  }
}
