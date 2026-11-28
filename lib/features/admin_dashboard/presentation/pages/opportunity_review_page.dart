import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';

import '../providers/opportunity_review_provider.dart';
import '../widgets/opportunity_review_card.dart';
import '../widgets/opportunity_review_empty_state.dart';
import 'opportunity_review_detail_page.dart';

class OpportunityReviewPage extends ConsumerStatefulWidget {
  const OpportunityReviewPage({super.key});

  @override
  ConsumerState<OpportunityReviewPage> createState() =>
      _OpportunityReviewPageState();
}

class _OpportunityReviewPageState extends ConsumerState<OpportunityReviewPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(opportunityReviewControllerProvider).loadOpportunityReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(opportunityReviewControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader.backTitle(title: 'Review Report Peluang'),

            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final state = controller.state;

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: controller.refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildSummary(
                          state.pendingCount,
                          state.underReviewCount,
                          state.totalReportCount,
                        ),

                        const SizedBox(height: 20),

                        if (state.isLoading && state.opportunities.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.errorMessage != null &&
                            state.opportunities.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                const Text('Gagal memuat data review.'),
                                TextButton(
                                  onPressed: controller.loadOpportunityReviews,
                                  child: const Text('Coba lagi'),
                                ),
                              ],
                            ),
                          )
                        else if (state.opportunities.isEmpty)
                          const OpportunityReviewEmptyState()
                        else ...[
                          const Text(
                            'Daftar Peluang',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 12),

                          ...state.opportunities.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: OpportunityReviewCard(
                                opportunity: item,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          OpportunityReviewDetailPage(
                                            opportunityId: item.opportunityId,
                                          ),
                                    ),
                                  );

                                  if (mounted) {
                                    controller.refresh();
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(int pending, int reviewing, int totalReports) {
    return Row(
      children: [
        Expanded(child: _summaryItem('Pending', pending, Colors.orange)),
        const SizedBox(width: 8),
        Expanded(child: _summaryItem('Review', reviewing, Colors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _summaryItem('Laporan', totalReports, Colors.red)),
      ],
    );
  }

  Widget _summaryItem(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
