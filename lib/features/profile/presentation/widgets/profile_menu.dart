import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'profile_menu_item.dart';

class ProfileMenu extends StatelessWidget {
  final bool isOnline;
  final bool isContributor;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onSaved;
  final VoidCallback onArchived;
  final VoidCallback onOffline;
  final Widget? additionalItem;
  final VoidCallback? onContriReq;

  const ProfileMenu({
    super.key,
    required this.isOnline,
    required this.isContributor,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onSaved,
    required this.onArchived,
    required this.onOffline,
    this.additionalItem,
    this.onContriReq,
  });

  @override
  Widget build(BuildContext context) {
    final contriReq = onContriReq;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            'Akun Pencari',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.heading,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Edit profil',
                subtitle: isOnline
                    ? 'Nama, username, email, dan wilayah'
                    : 'Tidak tersedia saat offline',
                isFirst: true,
                isEnabled: isOnline,
                onTap: isOnline ? onEditProfile : onOffline,
              ),

              ProfileMenuItem(
                icon: Icons.shield_outlined,
                title: 'Keamanan',
                subtitle: isOnline
                    ? 'Ubah dan lindungi kata sandi akun'
                    : 'Tidak tersedia saat offline',
                isEnabled: isOnline,
                onTap: isOnline ? onChangePassword : onOffline,
              ),

              ProfileMenuItem(
                icon: Icons.bookmark_added_rounded,
                title: 'Tersimpan',
                subtitle: 'Lihat Peluang yang kamu simpan',
                isLast: !isContributor && additionalItem == null,
                onTap: onSaved,
              ),

              if (!isContributor && contriReq != null)
                ProfileMenuItem(
                  icon: Icons.library_books_rounded,
                  title: 'Pengajuan Kontributor',
                  subtitle: 'Jadilah Kontributor untuk kontribusi lebih baik',
                  onTap: contriReq,
                ),

              if (isContributor)
                ProfileMenuItem(
                  icon: Icons.archive_outlined,
                  title: 'Arsip Peluang',
                  subtitle: 'Lihat peluang yang telah diposting',
                  isLast: additionalItem == null,
                  onTap: onArchived,
                ),

              ?additionalItem,
            ],
          ),
        ),
      ],
    );
  }
}
