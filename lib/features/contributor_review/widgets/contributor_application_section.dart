import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../pages/admin_dashboard_page.dart';
import '../repository/contributor_application_repository.dart';

/// Item menu khusus admin di dalam `ProfileMenu` untuk membuka
/// [AdminDashboardPage]. Pemberitahuan/bubble notifikasi dihapus agar halaman
/// profil tetap bersih karena ringkasan pengajuan terpusat di Dashboard Admin.
class ContributorApplicationSection extends StatelessWidget {
  final ContributorApplicationRepository repository;
  final String? adminName;
  final String? regionName;

  const ContributorApplicationSection({
    super.key,
    required this.repository,
    this.adminName,
    this.regionName,
  });

  void _openAdminDashboard(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AdminDashboardPage(
          repository: repository,
          adminName: adminName,
          regionName: regionName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bottomRadius = BorderRadius.vertical(bottom: Radius.circular(13));

    return Material(
      color: AppColors.surface,
      borderRadius: bottomRadius,
      child: InkWell(
        key: const Key('admin_dashboard_entry_card'),
        onTap: () => _openAdminDashboard(context),
        borderRadius: bottomRadius,
        child: Container(
          width: double.infinity,
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
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard Admin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Kelola pengajuan kontributor & admin wilayah',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                color: AppColors.heading,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
