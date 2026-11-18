import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'profile_menu_item.dart';

class ProfileMenu extends StatelessWidget {
  final bool isOnline;

  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onSync;
  final VoidCallback onHelp;
  final VoidCallback onOffline;

  const ProfileMenu({
    super.key,
    required this.isOnline,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onSync,
    required this.onOffline,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            'Akun Pencari',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.heading,
              fontWeight: FontWeight.w400,
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
                icon: Icons.grid_view_rounded,
                title: 'Sinkronisasi offline',
                subtitle: 'Kelola data profil offline',
                onTap: onSync,
              ),

              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Bantuan',
                subtitle: 'Tanyakan hal terkait aplikasi TeraNusa',
                isLast: true,
                onTap: onHelp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
