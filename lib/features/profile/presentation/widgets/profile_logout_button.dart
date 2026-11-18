import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';

class ProfileLogoutButton extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onPressed;

  const ProfileLogoutButton({
    super.key,
    required this.isOnline,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Keluar dari akun',
      height: 50,
      isExpanded: true,
      backgroundColor: const Color(0xFFFFF5F2),
      foregroundColor: const Color(0xFFA55749),
      textColor: const Color(0xFFA55749),
      borderColor: const Color(0xFFEFCBC4),
      disabledBackgroundColor: const Color(0xFFE8E3E1),
      disabledForegroundColor: const Color(0xFF99918E),
      onPressed: isOnline ? onPressed : null,
    );
  }
}
