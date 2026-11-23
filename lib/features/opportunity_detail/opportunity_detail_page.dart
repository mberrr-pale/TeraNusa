import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/presentation/providers/auth_provider.dart';
import '../saved/presentation/providers/saved_opportunity_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_action_button.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_bottom_sheet.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/expandable_description.dart';
import '../../core/widgets/guest_access_guard.dart';
import '../../core/utils/bookmark_action_helper.dart';
import '../../core/providers/internet_provider.dart';
import '../../data/models/opportunity.dart';

class OpportunityDetailPage extends ConsumerStatefulWidget {
  final Opportunity opportunity;

  const OpportunityDetailPage({super.key, required this.opportunity});

  @override
  ConsumerState<OpportunityDetailPage> createState() =>
      _OpportunityDetailPageState();
}

class _OpportunityDetailPageState extends ConsumerState<OpportunityDetailPage> {
  Opportunity get opportunity => widget.opportunity;

  bool get _isOnline => ref.read(internetStatusProvider).asData?.value == true;

  void _showOfflineMessage(BuildContext context) {
    AppSnackBar.showError(
      context,
      title: 'Koneksi internet diperlukan',
      message: 'Hubungkan ke internet untuk menggunakan fitur ini.',
    );
  }

  String _getCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'lowongan':
        return 'Lowongan';
      case 'event':
        return 'Event';
      case 'pemberdayaan':
        return 'Pemberdayaan';
      case 'produk_jasa':
        return 'Produk & Jasa';
      default:
        return category;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'lowongan':
        return Icons.work_outline_rounded;
      case 'event':
        return Icons.event_outlined;
      case 'pemberdayaan':
        return Icons.groups_outlined;
      case 'produk_jasa':
        return Icons.storefront_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  Future<void> _shareOpportunity() async {
    final source = opportunity.source?.trim();
    final contact = opportunity.contact?.trim();

    final shareText = [
      opportunity.title,
      '',
      'Kategori: ${_getCategoryName(opportunity.category)}',
      'Wilayah: ${opportunity.regionName ?? 'Tidak diketahui'}',
      'Berlaku hingga: ${_formatDate(opportunity.endDate)}',
      '',
      opportunity.description,
      '',
      'Sumber: ${source?.isNotEmpty == true ? source : 'Tidak tersedia'}',
      if (contact?.isNotEmpty == true) 'Kontak: $contact',
      '',
      'Temukan peluang menarik lainnya melalui aplikasi TeraNusa.',
    ].join('\n');

    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  Future<void> _showReportBottomSheet(BuildContext context) async {
    String? selectedReason;
    String otherReasonText = '';

    const reasons = [
      'Informasi tidak benar atau menyesatkan',
      'Peluang sudah kedaluwarsa',
      'Penipuan atau mencurigakan',
      'Konten tidak pantas',
      'Lainnya',
    ];

    final shouldShowFeedback = await AppBottomSheet.show<bool>(
      context: context,
      title: 'Laporkan Peluang',
      contentBuilder: (sheetContext, setSheetState) {
        final isOtherSelected = selectedReason == 'Lainnya';

        final canSubmit =
            selectedReason != null &&
            (!isOtherSelected || otherReasonText.trim().isNotEmpty);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bantu kami menjaga TeraNusa tetap aman dan terpercaya. '
              'Pilih alasan pelaporan yang sesuai.',
              style: AppTextStyles.body.copyWith(height: 1.5),
            ),

            const SizedBox(height: 14),

            RadioGroup<String>(
              groupValue: selectedReason,
              onChanged: (value) {
                setSheetState(() {
                  selectedReason = value;
                });
              },
              child: Column(
                children: reasons.map((reason) {
                  final isSelected = selectedReason == reason;

                  return InkWell(
                    onTap: () {
                      setSheetState(() {
                        selectedReason = reason;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: reason,
                            activeColor: AppColors.primary,
                          ),
                          Expanded(
                            child: Text(
                              reason,
                              style: AppTextStyles.body.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            if (isOtherSelected) ...[
              const SizedBox(height: 8),
              Text(
                'Jelaskan alasan laporan',
                style: AppTextStyles.label.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                minLines: 3,
                maxLines: 3,
                onChanged: (value) {
                  setSheetState(() {
                    otherReasonText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Tuliskan alasan laporan...',
                  hintStyle: AppTextStyles.secondary,
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            AppButton(
              label: 'Kirim Laporan',
              onPressed: canSubmit
                  ? () {
                      FocusScope.of(sheetContext).unfocus();
                      Navigator.of(sheetContext).pop(true);
                    }
                  : null,
              height: 50,
            ),
          ],
        );
      },
    );

    if (shouldShowFeedback == true && context.mounted) {
      AppSnackBar.showError(
        context,
        title: 'Fitur belum tersedia',
        message: 'Pelaporan peluang belum dapat digunakan saat ini.',
      );
    }
  }

  Widget _buildHeroImage(Color categoryColor, Color categoryBackground) {
    final localImageBytes = opportunity.localImageBytes;
    final imageUrl = opportunity.imageUrl;

    // Prioritaskan gambar lokal agar tetap tersedia saat offline.
    if (localImageBytes != null && localImageBytes.isNotEmpty) {
      return Image.memory(
        localImageBytes,
        width: double.infinity,
        height: 260,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageFallback(categoryColor, categoryBackground);
        },
      );
    }

    // Jika tidak ada gambar lokal, gunakan URL gambar.
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return _buildImageFallback(categoryColor, categoryBackground);
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      height: 260,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildImageFallback(categoryColor, categoryBackground);
      },
    );
  }

  Widget _buildImageFallback(Color categoryColor, Color categoryBackground) {
    return Container(
      width: double.infinity,
      height: 260,
      color: categoryBackground,
      alignment: Alignment.center,
      child: Icon(
        _getCategoryIcon(opportunity.category),
        size: 58,
        color: categoryColor,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.pageTitle.copyWith(fontSize: 16));
  }

  Widget _buildCategoryBadge(Color categoryColor, Color categoryBackground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: categoryBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(opportunity.category),
            color: categoryColor,
            size: 14,
          ),
          const SizedBox(width: 7),
          Text(
            _getCategoryName(opportunity.category),
            style: TextStyle(
              color: categoryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return SizedBox(
      height: 76,
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        backgroundColor: AppColors.white,
        borderRadius: 13,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: AppColors.primary),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.secondary.copyWith(fontSize: 10.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceInfo() {
    final source = opportunity.source?.trim();

    return AppBadge(
      label: source?.isNotEmpty == true ? source! : 'Sumber belum tersedia',
      type: AppBadgeType.success,
      icon: Icons.verified_rounded,
      fullWidth: true,
      height: 52,
      bordered: true,
    );
  }

  Widget _buildSecurityWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.shield_rounded, color: AppColors.error, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tetap waspada dan verifikasi informasi '
              'sebelum membagikan data pribadi atau '
              'melakukan transaksi. Jangan pernah '
              'membagikan OTP, kata sandi, maupun '
              'informasi keuangan.',
              style: AppTextStyles.label.copyWith(fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isGuest,
    bool isSaved,
  ) {
    return Row(
      children: [
        Expanded(
          child: AppActionButton(
            label: isSaved ? 'Tersimpan' : 'Simpan',
            icon: isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            onPressed: () async {
              if (isGuest) {
                await GuestAccessGuard.check(context, ref);
                return;
              }

              await BookmarkActionHelper.toggle(
                context: context,
                ref: ref,
                opportunityId: opportunity.opportunityId,
                isSaved: isSaved,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppActionButton(
            label: 'Bagikan',
            icon: Icons.share_outlined,
            onPressed: () {
              if (!_isOnline) {
                _showOfflineMessage(context);
                return;
              }

              _shareOpportunity();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppActionButton(
            label: 'Laporkan',
            icon: Icons.report_gmailerrorred_outlined,
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onPressed: () async {
              if (!_isOnline) {
                _showOfflineMessage(context);
                return;
              }

              if (isGuest) {
                await GuestAccessGuard.check(context, ref);
                return;
              }

              _showReportBottomSheet(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showContactConfirmation(BuildContext context) async {
    // Periksa koneksi sebelum menampilkan dialog.
    if (!_isOnline) {
      _showOfflineMessage(context);
      return;
    }

    final shouldContinue = await AppDialog.show(
      context,
      title: 'Peringatan Keamanan',
      message:
          '\nKamu akan diarahkan ke aplikasi atau situs eksternal '
          'untuk menghubungi sumber peluang.\n\n'
          'Pastikan kamu tetap berhati-hati.\n'
          'Jangan membagikan informasi pribadi yang sensitif, '
          'dan waspadai permintaan biaya yang tidak jelas.',
      type: AppDialogType.warning,
      confirmLabel: 'Ya, Lanjutkan',
      cancelLabel: 'Batal',
    );

    // Periksa kembali koneksi setelah dialog ditutup.
    if (shouldContinue == true && context.mounted) {
      if (!_isOnline) {
        _showOfflineMessage(context);
        return;
      }

      await _contactSource(context);
    }
  }

  Future<void> _contactSource(BuildContext context) async {
    if (!_isOnline) {
      _showOfflineMessage(context);
      return;
    }

    final contact = opportunity.contact?.trim();

    if (contact == null || contact.isEmpty) {
      AppSnackBar.showError(
        context,
        title: 'Kontak tidak tersedia',
        message: 'Sumber belum mencantumkan informasi kontak.',
      );
      return;
    }

    final uri = Uri.tryParse(contact);

    if (uri == null ||
        !['https', 'http', 'tel', 'mailto'].contains(uri.scheme)) {
      AppSnackBar.showError(
        context,
        title: 'Kontak tidak valid',
        message: 'Informasi kontak sumber tidak dapat dibuka.',
      );
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        AppSnackBar.showError(
          context,
          title: 'Gagal membuka kontak',
          message: 'Silakan coba lagi nanti.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        AppSnackBar.showError(
          context,
          title: 'Gagal membuka kontak',
          message: 'Silakan coba lagi nanti.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final savedIdsState = ref.watch(savedOpportunityIdsProvider);

    final user = authState.asData?.value;

    final isGuest = !authState.isLoading && !authState.hasError && user == null;

    final savedIds = savedIdsState.asData?.value ?? <String>{};

    final isSaved =
        opportunity.opportunityId != null &&
        savedIds.contains(opportunity.opportunityId);

    final categoryColor = AppColors.categoryColor(opportunity.category);

    final categoryBackground = AppColors.categoryBackground(
      opportunity.category,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    // Gambar dimulai sedikit di bawah header.
                    Positioned(
                      top: 40,
                      left: 0,
                      right: 0,
                      child: _buildHeroImage(categoryColor, categoryBackground),
                    ),

                    // Header berada di atas gambar.
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppHeader.backTitle(
                        title: 'Detail Peluang',
                        overlay: false,
                      ),
                    ),
                  ],
                ),
              ),

              // Content card yang menumpuk pada gambar.
              Transform.translate(
                offset: const Offset(0, -14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul di kiri dan badge kategori di kanan.
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              opportunity.title,
                              style: AppTextStyles.pageTitle.copyWith(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildCategoryBadge(
                            categoryColor,
                            categoryBackground,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Informasi wilayah dan masa berlaku.
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.location_on_sharp,
                              label: 'Wilayah',
                              value:
                                  opportunity.regionName ?? 'Tidak diketahui',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.calendar_month_rounded,
                              label: 'Berlaku hingga',
                              value: _formatDate(opportunity.endDate),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const Divider(color: AppColors.border),

                      const SizedBox(height: 12),

                      // Deskripsi peluang.
                      _buildSectionTitle('Tentang Peluang'),

                      const SizedBox(height: 10),

                      ExpandableDescription(
                        description: opportunity.description,
                        textStyle: AppTextStyles.body.copyWith(height: 1.6),
                      ),

                      const SizedBox(height: 16),

                      const Divider(color: AppColors.border),

                      const SizedBox(height: 12),

                      // Informasi sumber.
                      _buildSectionTitle('Informasi Sumber'),

                      const SizedBox(height: 10),

                      _buildSourceInfo(),

                      const SizedBox(height: 18),

                      // Peringatan keamanan.
                      _buildSecurityWarning(),

                      const SizedBox(height: 18),

                      // Button Action.
                      _buildActionButtons(context, ref, isGuest, isSaved),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: AppButton(
            label: 'Hubungi sumber',
            icon: Icons.chat_rounded,
            trailingIcon: Icons.arrow_forward_ios_rounded,
            onPressed: () => _showContactConfirmation(context),
            height: 50,
          ),
        ),
      ),
    );
  }
}
