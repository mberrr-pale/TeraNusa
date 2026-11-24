import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/opportunity_card.dart';
import '../providers/archived_opportunity_provider.dart';

class ArchivedPage extends ConsumerWidget {
  const ArchivedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedState = ref.watch(archivedOpportunitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arsip Peluang',
                    style: AppTextStyles.pageTitle.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Riwayat peluang yang telah diposting.',
                    style: AppTextStyles.secondary,
                  ),
                ],
              ),
            ),

            Expanded(
              child: archivedState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),

                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 42,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat arsip peluang.',
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            ref.invalidate(archivedOpportunitiesProvider);
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                ),

                data: (opportunities) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      await ref
                          .read(archivedOpportunityIdsProvider.notifier)
                          .refresh();

                      await ref.read(archivedOpportunitiesProvider.future);
                    },
                    child: opportunities.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(24),
                            children: [
                              SizedBox(
                                height: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.archive_outlined,
                                      size: 56,
                                      color: AppColors.secondaryText.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'Belum Ada Arsip',
                                      style: AppTextStyles.pageTitle.copyWith(
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Peluang yang telah diposting akan '
                                      'ditampilkan di sini.',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.secondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                            itemCount: opportunities.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 9),
                            itemBuilder: (context, index) {
                              final opportunity = opportunities[index];

                              return OpportunityCard(
                                opportunity: opportunity,
                                regionName:
                                    opportunity.regionName ??
                                    'Wilayah tidak diketahui',
                                showBookmark: false,
                                isArchived: opportunity.status == 'archived',
                                isHistory: true,
                                onTap: () {
                                  context.push(
                                    AppRoutes.archivedOpportunityDetail,
                                    extra: opportunity,
                                  );
                                },
                              );
                            },
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }
}
