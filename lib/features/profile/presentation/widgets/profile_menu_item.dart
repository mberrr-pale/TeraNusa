import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  final bool isFirst;
  final bool isLast;
  final bool isEnabled;

  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(14) : Radius.zero,
        bottom: isLast ? const Radius.circular(14) : Radius.zero,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(14) : Radius.zero,
          bottom: isLast ? const Radius.circular(14) : Radius.zero,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
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
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isEnabled ? AppColors.heading : Colors.grey,
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
