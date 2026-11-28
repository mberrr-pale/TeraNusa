import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class ContributorApplicationSection extends StatelessWidget {
  final String? adminName;
  final String? regionName;

  const ContributorApplicationSection({
    super.key,
    this.adminName,
    this.regionName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        key: const Key('admin_dashboard_entry_card'),
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          context.push(
            '/admin-dashboard',
            extra: {'adminName': adminName, 'regionName': regionName},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard Admin',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Kelola pengajuan kontributor & admin wilayah',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.heading),
            ],
          ),
        ),
      ),
    );
  }
}
