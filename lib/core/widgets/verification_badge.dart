import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class VerificationBadge extends StatelessWidget {
  final String category;

  const VerificationBadge({super.key, required this.category});

  String get _categoryLabel {
    switch (category) {
      case 'lowongan':
        return 'Lowongan';
      case 'event':
        return 'Event';
      case 'pemberdayaan':
        return 'Pemberdayaan';
      case 'produk_jasa':
        return 'Produk & Jasa';
      default:
        return 'Lainnya';
    }
  }

  Color get _categoryColor {
    switch (category) {
      case 'lowongan':
        return AppColors.job;
      case 'event':
        return AppColors.event;
      case 'pemberdayaan':
        return AppColors.empowerment;
      case 'produk_jasa':
        return AppColors.product;
      default:
        return AppColors.primary;
    }
  }

  Color get _categoryBackground {
    switch (category) {
      case 'lowongan':
        return AppColors.jobBackground;
      case 'event':
        return AppColors.eventBackground;
      case 'pemberdayaan':
        return AppColors.empowermentBackground;
      case 'produk_jasa':
        return AppColors.productBackground;
      default:
        return AppColors.background;
    }
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: _categoryBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        _categoryLabel,
        style: TextStyle(
          color: _categoryColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.empowermentBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 13, color: AppColors.primary),
          SizedBox(width: 4),
          Text(
            'Terverifikasi',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCategoryBadge(),
        const SizedBox(width: 6),
        _buildVerificationBadge(),
      ],
    );
  }
}
