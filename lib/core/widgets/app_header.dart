import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final bool showBackButton;
  final bool overlay;
  final Widget? trailing;

  // Header utama.
  const AppHeader({super.key})
    : title = null,
      showBackButton = false,
      overlay = false,
      trailing = null;

  // Header halaman.
  const AppHeader.backTitle({
    super.key,
    required this.title,
    this.overlay = false,
    this.trailing,
  }) : showBackButton = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: overlay
            ? Colors.transparent
            : showBackButton
            ? AppColors.white
            : AppColors.background,
        border: overlay
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
      ),
      child: showBackButton
          ? _buildBackTitle(context)
          : _buildBrandHeader(context),
    );
  }

  Widget _buildBackTitle(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.heading,
                size: 20,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            title!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: overlay ? AppColors.white : AppColors.heading,
            ),
          ),
        ),
        if (trailing != null)
          Align(
            alignment: Alignment.centerRight,
            child: trailing!,
          ),
      ],
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final hasSession = snapshot.hasData
            ? snapshot.data!.session != null
            : Supabase.instance.client.auth.currentSession != null;

        return Row(
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
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Peluang lokal, lebih dekat',
                  style: AppTextStyles.secondary.copyWith(fontSize: 12),
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
        );
      },
    );
  }
}
