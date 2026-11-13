import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final hasSession = snapshot.hasData
            ? snapshot.data!.session != null
            : Supabase.instance.client.auth.currentSession != null;

        return Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: const Icon(
                  Icons.travel_explore,
                  color: AppColors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 9),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TeraNusa',
                    style: AppTextStyles.cardTitle.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Peluang lokal, lebih dekat',
                    style: AppTextStyles.secondary.copyWith(fontSize: 8),
                  ),
                ],
              ),
              const Spacer(),

              if (hasSession)
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Notifikasi'),
                          content: const Text(
                            'Fitur notifikasi sedang dalam tahap pengembangan.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Mengerti'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.heading,
                    size: 22,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
