import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/bookmark_action_helper.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/states/app_error.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../../../core/widgets/opportunity_card.dart';
import '../providers/saved_opportunity_provider.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedOpportunities = ref.watch(savedOpportunitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),

            Expanded(
              child: savedOpportunities.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (error, stackTrace) => AppError(
                  message: 'Gagal memuat peluang tersimpan.',
                  onRetry: () {
                    ref.invalidate(savedOpportunitiesProvider);
                  },
                ),

                data: (opportunities) {
                  if (opportunities.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bookmark_border_rounded,
                              size: 56,
                              color: AppColors.secondaryText,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum Ada Peluang Tersimpan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Peluang yang kamu simpan akan muncul di sini.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: opportunities.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final opportunity = opportunities[index];

                      return OpportunityCard(
                        opportunity: opportunity,
                        regionName:
                            opportunity.regionName ?? 'Wilayah tidak diketahui',
                        isSaved: true,
                        onTap: () {
                          context.push(
                            AppRoutes.opportunityDetail,
                            extra: opportunity,
                          );
                        },
                        onBookmarkTap: () async {
                          await BookmarkActionHelper.toggle(
                            context: context,
                            ref: ref,
                            opportunityId: opportunity.opportunityId,
                            isSaved: true,
                          );
                        },
                      );
                    },
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
