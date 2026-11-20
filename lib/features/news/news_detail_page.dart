import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/expandable_description.dart';
import '../../data/models/news.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;

  const NewsDetailPage({super.key, required this.news});

  // Layout constants
  static const double _horizontalPadding = 20;
  static const double _heroImageHeight = 260;
  static const double _headerHeight = 300;
  static const double _infoCardHeight = 68;
  static const double _contentTopOffset = -14;

  static const double _smallSpacing = 12;
  static const double _sectionSpacing = 20;
  static const double _contentTopPadding = 24;
  static const double _contentBottomPadding = 30;

  static const double _buttonVerticalPadding = 12;

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

  Future<void> _shareNews() async {
    final url = news.sourceUrl.trim();

    if (url.isEmpty) return;

    try {
      await SharePlus.instance.share(
        ShareParams(title: news.title, text: '${news.title}\n\n$url'),
      );
    } catch (error) {
      debugPrint('Gagal membagikan berita: $error');
    }
  }

  Future<void> _openSource(BuildContext context) async {
    final uri = Uri.tryParse(news.sourceUrl.trim());

    final isValidUrl =
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;

    if (!isValidUrl) {
      AppSnackBar.showError(
        context,
        title: 'Tautan tidak valid',
        message: 'Alamat sumber berita tidak dapat dibuka.',
      );
      return;
    }

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success && context.mounted) {
        _showOpenError(context);
      }
    } catch (error) {
      debugPrint('Gagal membuka sumber berita: $error');

      if (context.mounted) {
        _showOpenError(context);
      }
    }
  }

  void _showOpenError(BuildContext context) {
    AppSnackBar.showError(
      context,
      title: 'Gagal membuka berita',
      message: 'Silakan coba kembali beberapa saat lagi.',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  Widget _buildImageFallback() {
    return Container(
      color: AppColors.primaryLight,
      child: const Center(
        child: Icon(
          Icons.newspaper_rounded,
          size: 60,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    final imageUrl = news.imageUrl.trim();

    return SizedBox(
      width: double.infinity,
      height: _heroImageHeight,
      child: imageUrl.isEmpty
          ? _buildImageFallback()
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;

                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildImageFallback();
              },
            ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return SizedBox(
      height: _infoCardHeight,
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: _smallSpacing,
          vertical: 8,
        ),
        backgroundColor: AppColors.white,
        borderRadius: 13,
        child: Row(
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: AppTextStyles.secondary.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul berita
        Text(
          news.title,
          textAlign: TextAlign.start,
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.heading,
          ),
        ),

        const SizedBox(height: _sectionSpacing),

        // Informasi sumber dan tanggal
        _buildInfoCard(
          icon: Icons.newspaper_rounded,
          value: news.source,
          label: _formatDate(news.publishedAt),
        ),

        const SizedBox(height: _sectionSpacing),

        const Divider(color: AppColors.border, thickness: 1, height: 1),

        const SizedBox(height: _sectionSpacing),

        // Ringkasan berita
        Text(
          'Ringkasan Berita',
          style: AppTextStyles.pageTitle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: _smallSpacing),

        ExpandableDescription(
          description: news.summary,
          textStyle: AppTextStyles.body.copyWith(height: 1.6),
        ),

        const SizedBox(height: 16),

        const Divider(color: AppColors.border),

        const SizedBox(height: _smallSpacing),

        // Informasi sumber eksternal
        const AppBadge(
          label:
              'Berita berasal dari sumber eksternal. '
              'Kamu akan diarahkan ke situs sumber '
              'untuk membaca artikel lengkap.',
          type: AppBadgeType.neutral,
          icon: Icons.info_rounded,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: _headerHeight,
      child: Stack(
        children: [
          Positioned(top: 40, left: 0, right: 0, child: _buildHeroImage()),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader.backTitle(
              title: 'Pratinjau Berita',
              overlay: false,
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  onPressed: _shareNews,
                  padding: EdgeInsets.zero,
                  tooltip: 'Bagikan berita',
                  icon: const Icon(
                    Icons.share_outlined,
                    color: AppColors.heading,
                    size: 19,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Transform.translate(
      offset: const Offset(0, _contentTopOffset),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          _horizontalPadding,
          _contentTopPadding,
          _horizontalPadding,
          _contentBottomPadding,
        ),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          _horizontalPadding,
          _buttonVerticalPadding,
          _horizontalPadding,
          _buttonVerticalPadding,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: AppButton(
          label: 'Lihat Berita',
          onPressed: () => _openSource(context),
          trailingIcon: Icons.open_in_new_rounded,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(), _buildArticleContent()],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }
}
