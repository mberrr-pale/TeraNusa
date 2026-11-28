import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

import '../../domain/entities/contributor_application.dart';
import 'dashboard_application_card.dart';
import 'dashboard_empty_state.dart';

import 'inline_sort_button.dart';

class DashboardApplicationSection extends StatelessWidget {
  final String title;
  final List<ContributorApplication> items;
  final bool newestFirst;
  final VoidCallback onToggleSort;
  final ValueChanged<ContributorApplication> onReview;

  const DashboardApplicationSection({
    super.key,
    required this.title,
    required this.items,
    required this.newestFirst,
    required this.onToggleSort,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InlineSortButton(newestFirst: newestFirst, onTap: onToggleSort),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          DashboardEmptyState(
            icon: Icons.inbox_outlined,
            iconColor: AppColors.primary,
            title: title == 'Pengajuan Kontributor'
                ? 'Belum ada pengajuan kontributor'
                : 'Belum ada pengajuan admin wilayah',
            message: title == 'Pengajuan Kontributor'
                ? 'Pengajuan dari calon kontributor akan ditampilkan di sini setelah mereka mengirimkan permohonan.'
                : 'Pengajuan admin wilayah akan ditampilkan di sini setelah ada permohonan baru.',
          )
        else
          ApplicationCarousel(items: items, onReview: onReview),
      ],
    );
  }
}

class ApplicationCarousel extends StatefulWidget {
  final List<ContributorApplication> items;
  final ValueChanged<ContributorApplication> onReview;

  const ApplicationCarousel({
    super.key,
    required this.items,
    required this.onReview,
  });

  @override
  State<ApplicationCarousel> createState() => _ApplicationCarouselState();
}

class _ApplicationCarouselState extends State<ApplicationCarousel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double get _progress {
    if (!_scrollController.hasClients ||
        !_scrollController.position.hasContentDimensions) {
      return 0;
    }

    final max = _scrollController.position.maxScrollExtent;

    if (max <= 0) return 0;

    return (_scrollController.offset / max).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final hasOverflow = widget.items.length > 2;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = hasOverflow
                ? ((constraints.maxWidth - 22) / 2.08)
                      .clamp(154.0, 204.0)
                      .toDouble()
                : ((constraints.maxWidth - 12) / 2)
                      .clamp(156.0, 210.0)
                      .toDouble();

            return SizedBox(
              height: 208,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                itemCount: widget.items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = widget.items[index];

                  return DashboardApplicationCard(
                    application: item,
                    width: width,
                    onReview: () => widget.onReview(item),
                  );
                },
              ),
            );
          },
        ),
        if (hasOverflow) ...[
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 56,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, _) {
                  return Align(
                    alignment: Alignment(-1 + (_progress * 2), 0),
                    child: Container(
                      width: 22,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
