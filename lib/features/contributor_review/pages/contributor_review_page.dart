import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/states/app_loading.dart';
import '../models/contributor_application.dart';
import '../repository/contributor_application_repository.dart';
import '../widgets/contributor_application_card.dart';
import '../widgets/review_sheet.dart';

/// Layar verifikasi & daftar pengajuan khusus admin (selaras dengan verifikasi.png)
/// dengan filter urutan high-fidelity Terlama & Terbaru.
class ContributorReviewPage extends StatefulWidget {
  final ContributorApplicationRepository repository;
  final ApplicationCategory? category;

  const ContributorReviewPage({
    super.key,
    required this.repository,
    this.category,
  });

  @override
  State<ContributorReviewPage> createState() => _ContributorReviewPageState();
}

class _ContributorReviewPageState extends State<ContributorReviewPage> {
  late Future<List<ContributorApplication>> _future;
  bool _oldestFirst = true;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getApplications();
  }

  void _reload() {
    setState(() {
      _future = widget.repository.getApplications();
    });
  }

  Future<void> _refresh() async {
    final future = widget.repository.getApplications();
    setState(() {
      _future = future;
    });
    try {
      await future;
    } catch (_) {
      // Error state ditangani oleh FutureBuilder.
    }
  }

  Future<void> _openReview(ContributorApplication app) async {
    final result = await showReviewSheet(
      context,
      application: app,
      onSubmit: (status, note) => widget.repository.updateStatus(
        id: app.id,
        status: status,
        note: note,
      ),
    );

    if (result == null || !mounted) return;

    _reload();

    final roleTarget = app.category == ApplicationCategory.regionalAdmin
        ? 'admin wilayah'
        : 'kontributor';
    final (title, message) = switch (result) {
      ApplicationStatus.approved => (
        'Pengajuan disetujui',
        '${app.fullName} disetujui sebagai $roleTarget.',
      ),
      ApplicationStatus.rejected => (
        'Pengajuan ditolak',
        'Pengajuan ${app.fullName} telah ditolak.',
      ),
      ApplicationStatus.pending => (
        'Pengajuan ditandai menunggu',
        'Catatan tinjauan untuk ${app.fullName} berhasil disimpan.',
      ),
    };

    AppSnackBar.showSuccess(context, title: title, message: message);
  }

  List<ContributorApplication> _scopeAndSort(
    List<ContributorApplication> items,
  ) {
    final scoped = widget.category == null
        ? List<ContributorApplication>.of(items)
        : items.where((e) => e.category == widget.category).toList();

    scoped.sort(
      (a, b) => _oldestFirst
          ? a.submittedAt.compareTo(b.submittedAt)
          : b.submittedAt.compareTo(a.submittedAt),
    );
    return scoped;
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = widget.category?.pageTitle ?? 'Pengajuan Kontributor';
    final badgeLabel = widget.category?.badgeLabel ?? 'AKSES WILAYAH';
    final emptyMessage =
        widget.category?.emptyMessage ?? 'Belum ada pengajuan kontributor.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader.backTitle(title: pageTitle),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: FutureBuilder<List<ContributorApplication>>(
                  future: _future,
                  builder: (context, snapshot) {
                    final allItems =
                        snapshot.data ?? const <ContributorApplication>[];
                    final visibleItems = _scopeAndSort(allItems);
                    final pendingCount = visibleItems
                        .where((e) => e.status == ApplicationStatus.pending)
                        .length;

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      children: [
                        // Pill tag akses
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.groups_outlined,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  badgeLabel,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Judul & deskripsi
                        const Text(
                          'Verifikasi identitas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Pastikan calon Admin Wilayah atau Kontributor benar-benar mewakili instansi sebelum memberikan akses.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Banner Verifikasi berjenjang
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 22,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Verifikasi berjenjang',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.heading,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Sebagai Admin terverifikasi, kamu hanya dapat menyetujui akun dari wilayah yang sama.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.4,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Ringkasan antrean + High-Fidelity Segmented Filter Terlama / Terbaru
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$pendingCount pengajuan menunggu',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                ),
                              ),
                            ),
                            if (visibleItems.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  '${visibleItems.length} total',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _SortSegmentedControl(
                          oldestFirst: _oldestFirst,
                          onChanged: (oldest) {
                            if (_oldestFirst == oldest) return;
                            setState(() => _oldestFirst = oldest);
                          },
                        ),
                        const SizedBox(height: 14),

                        // Konten daftar
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: AppLoading(
                              message: 'Memuat pengajuan...',
                            ),
                          )
                        else if (snapshot.hasError)
                          _MessageCard(
                            icon: Icons.error_outline_rounded,
                            iconColor: AppColors.error,
                            text: 'Gagal memuat pengajuan kontributor.',
                            actionLabel: 'Coba lagi',
                            onAction: _reload,
                          )
                        else if (visibleItems.isEmpty)
                          _MessageCard(
                            icon: Icons.inbox_outlined,
                            iconColor: AppColors.primary,
                            text: emptyMessage,
                          )
                        else
                          ...List.generate(visibleItems.length, (index) {
                            final item = visibleItems[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == visibleItems.length - 1
                                    ? 0
                                    : 12,
                              ),
                              child: ContributorApplicationCard(
                                application: item,
                                onReview: () => _openReview(item),
                              ),
                            );
                          }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kontrol filter urutan high-fidelity (Terlama | Terbaru) agar mudah dilihat
/// dan dioperasikan oleh admin.
class _SortSegmentedControl extends StatelessWidget {
  final bool oldestFirst;
  final ValueChanged<bool> onChanged;

  const _SortSegmentedControl({
    required this.oldestFirst,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SortSegmentItem(
              key: const Key('sort_oldest_button'),
              label: 'Terlama',
              icon: Icons.history_rounded,
              selected: oldestFirst,
              onTap: () => onChanged(true),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _SortSegmentItem(
              key: const Key('sort_newest_button'),
              label: 'Terbaru',
              icon: Icons.schedule_rounded,
              selected: !oldestFirst,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortSegmentItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SortSegmentItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.white : AppColors.secondaryText,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? AppColors.white : AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageCard({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: AppColors.surface,
      borderRadius: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: iconColor),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 10),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
