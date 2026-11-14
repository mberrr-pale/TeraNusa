import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 15, 14, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TeraNusaHeader(),
              _buildProfileHeader(),

              const SizedBox(height: 20),

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
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit profil',
                      subtitle: 'Nama, username, email, dan wilayah',
                      isFirst: true,
                      onTap: () {},
                    ),

                    _buildMenuItem(
                      icon: Icons.shield_outlined,
                      title: 'Keamanan',
                      subtitle: 'Ubah dan lindungi kata sandi akun',
                      onTap: () {},
                    ),

                    _buildMenuItem(
                      icon: Icons.grid_view_rounded,
                      title: 'Sinkronisasi offline',
                      subtitle: 'Terakhir disinkron hari ini',
                      onTap: () {},
                    ),

                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      subtitle: 'Tanyakan hal terkait aplikasi TeraNusa',
                      isLast: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ================= PROFILE HEADER =================

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          height: 105,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),

        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(17, 51, 17, 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(19),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ayu Rahmawati',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.heading,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '@ayurahma · ayu@teranusa.id',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // Foto profil
            Positioned(
              left: 18,
              top: -39,
              child: Stack(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.bannerStart,
                      border: Border.all(color: AppColors.white, width: 4),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.bannerStart,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        border: Border.all(color: AppColors.white, width: 2),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Badge role
            Positioned(
              right: 10,
              top: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  border: Border.all(color: AppColors.bannerStart),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withOpacity(0.1),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: AppColors.primary, size: 12),
                    SizedBox(width: 5),
                    Text(
                      'Pencari',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= MENU ITEM =================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(14) : Radius.zero,
        bottom: isLast ? const Radius.circular(14) : Radius.zero,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : const BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: AppColors.primary, size: 19),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.heading,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: AppColors.heading, size: 20),
          ],
        ),
      ),
    );
  }

  // ================= LOGOUT BUTTON =================

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text(
              'Keluar dari akun',
              style: TextStyle(color: AppColors.heading),
            ),
            content: const Text(
              'Apakah kamu yakin ingin keluar dari akun?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Tambahkan proses logout di sini.
                },
                child: const Text(
                  'Keluar',
                  style: TextStyle(color: Color(0xFFA55749)),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F2),
          border: Border.all(color: const Color(0xFFEFCBC4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Keluar dari akun',
          style: TextStyle(fontSize: 16, color: Color(0xFFA55749)),
        ),
      ),
    );
  }
}
