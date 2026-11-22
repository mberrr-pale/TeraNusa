import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
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

                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Gagal Memuat Peluang Tersimpan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Silakan coba muat ulang halaman.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(savedOpportunitiesProvider);
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
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
                          final opportunityId = opportunity.opportunityId;

                          if (opportunityId == null || opportunityId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ID peluang tidak ditemukan.'),
                              ),
                            );
                            return;
                          }

                          try {
                            await ref
                                .read(savedOpportunityIdsProvider.notifier)
                                .toggleSavedOpportunity(opportunityId);
                          } catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Gagal menghapus peluang dari daftar tersimpan.',
                                ),
                              ),
                            );
                          }
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
