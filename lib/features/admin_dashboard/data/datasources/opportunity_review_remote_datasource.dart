import 'package:supabase_flutter/supabase_flutter.dart';

abstract class OpportunityReviewRemoteDataSource {
  Future<List<Map<String, dynamic>>> getOpportunityReviews();

  Future<Map<String, dynamic>> getOpportunityReviewDetail(String opportunityId);

  Future<List<Map<String, dynamic>>> getOpportunityReports(
    String opportunityId,
  );

  Future<void> startOpportunityReview(String opportunityId);

  Future<void> submitOpportunityReview({
    required String opportunityId,
    required String status,
    required String note,
  });

  Future<void> updateReportStatus({
    required String reportId,
    required String status,
    required String adminNote,
  });
}

class OpportunityReviewRemoteDataSourceImpl
    implements OpportunityReviewRemoteDataSource {
  final SupabaseClient supabase;

  OpportunityReviewRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<Map<String, dynamic>>> getOpportunityReviews() async {
    final response = await supabase
        .from('opportunities')
        .select('''
          opportunity_id,
          title,
          description,
          category,
          region_id,
          end_date,
          image_url,
          status,
          review_status,
          review_cycle,
          report_count,
          last_reviewed_report_count,
          review_started_at,
          reviewed_at,
          review_note,
          created_at
        ''')
        .inFilter('review_status', ['pending_review', 'under_review'])
        .eq('status', 'active')
        .isFilter('deleted_at', null)
        .order('report_count', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getOpportunityReports(
    String opportunityId,
  ) async {
    final response = await supabase
        .from('reports')
        .select('''
      *,
      profiles:reporter_user_id (
        user_id,
        name
      )
    ''')
        .eq('opportunity_id', opportunityId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> startOpportunityReview(String opportunityId) async {
    await supabase.rpc(
      'start_opportunity_review',
      params: {'p_opportunity_id': opportunityId},
    );
  }

  @override
  Future<void> submitOpportunityReview({
    required String opportunityId,
    required String status,
    required String note,
  }) async {
    await supabase.rpc(
      'submit_opportunity_review',
      params: {
        'p_opportunity_id': opportunityId,
        'p_review_status': status,
        'p_review_note': note,
      },
    );
  }

  @override
  Future<void> updateReportStatus({
    required String reportId,
    required String status,
    required String adminNote,
  }) async {
    await supabase.rpc(
      'update_opportunity_report_status',
      params: {
        'p_report_id': reportId,
        'p_status': status,
        'p_admin_note': adminNote,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getOpportunityReviewDetail(
    String opportunityId,
  ) async {
    final response = await supabase
        .from('opportunities')
        .select('''
        opportunity_id,
        title,
        description,
        category,
        region_id,
        end_date,
        source,
        contact,
        image_url,
        status,
        review_status,
        review_cycle,
        report_count,
        last_reviewed_report_count,
        review_started_at,
        reviewed_at,
        reviewed_by,
        review_note,
        created_at
      ''')
        .eq('opportunity_id', opportunityId)
        .isFilter('deleted_at', null)
        .single();

    return response;
  }
}
