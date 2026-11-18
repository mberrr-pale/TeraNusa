import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_header.dart';
import '../../data/models/opportunity.dart';

class OpportunityDetailPage extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailPage({super.key, required this.opportunity});

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

  String _formatDate(DateTime date) {
    const months = [
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildHeroImage(Color categoryColor, Color categoryBackground) {
    final imageUrl = opportunity.imageUrl;

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
    return Text(
      title,
      style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
    );
  }

  Widget _buildCategoryBadge(Color categoryColor, Color categoryBackground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            size: 17,
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

  Widget _buildLocationInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 19,
          color: AppColors.secondaryText,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            opportunity.regionName ?? 'Wilayah tidak diketahui',
            style: AppTextStyles.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryInfo() {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 17,
          color: AppColors.secondaryText,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            'Berlaku hingga ${_formatDate(opportunity.endDate)}',
            style: AppTextStyles.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceInfo() {
    final source = opportunity.source?.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        source != null && source.isNotEmpty
            ? source
            : 'Informasi sumber belum tersedia.',
        style: AppTextStyles.secondary.copyWith(fontSize: 12),
      ),
    );
  }

  Widget _buildSecurityWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'Tetap waspada dan verifikasi informasi '
              'sebelum membagikan data pribadi atau '
              'melakukan transaksi. Jangan pernah '
              'membagikan OTP, kata sandi, maupun '
              'informasi keuangan.',
              style: AppTextStyles.body.copyWith(fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.categoryColor(opportunity.category);

    final categoryBackground = AppColors.categoryBackground(
      opportunity.category,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
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

                    // Header berada di atas dan sedikit menutupi gambar.
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
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori.
                      _buildCategoryBadge(categoryColor, categoryBackground),

                      const SizedBox(height: 14),

                      // Judul peluang.
                      Text(
                        opportunity.title,
                        style: AppTextStyles.pageTitle.copyWith(fontSize: 23),
                      ),

                      const SizedBox(height: 24),

                      // Informasi wilayah dan masa berlaku.
                      _buildLocationInfo(),

                      const SizedBox(height: 9),

                      _buildExpiryInfo(),

                      const SizedBox(height: 25),

                      const Divider(color: AppColors.border),

                      const SizedBox(height: 18),

                      // Deskripsi peluang.
                      _buildSectionTitle('Tentang Peluang'),

                      const SizedBox(height: 10),

                      Text(
                        opportunity.description,
                        style: AppTextStyles.body.copyWith(height: 1.6),
                      ),

                      const SizedBox(height: 22),

                      const Divider(color: AppColors.border),

                      const SizedBox(height: 18),

                      // Informasi sumber.
                      _buildSectionTitle('Informasi Sumber'),

                      const SizedBox(height: 10),

                      _buildSourceInfo(),

                      const SizedBox(height: 22),

                      // Peringatan keamanan.
                      _buildSecurityWarning(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
