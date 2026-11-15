import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import 'app_dialog.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/opportunities');
        break;
      case 2:
        context.go('/news');
        break;
      case 3:
        _showPageInfo(
          context,
          'Profil',
          'Halaman Profil sedang dalam tahap pengembangan.',
        );
        break;
    }
  }

  void _showPageInfo(BuildContext context, String title, String message) {
    AppDialog.show(context, title: title, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondaryText,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Peluang'),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper_outlined),
          label: 'Berita',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
