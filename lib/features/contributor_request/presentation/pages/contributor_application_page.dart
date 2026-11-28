import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/contributor_req_provider.dart';
import '../providers/contributor_req_action_provider.dart';
import '../../domain/entities/contributor_request.dart';
import '../widgets/contributor_profile_form.dart';

class ContributorApplicationSheet extends ConsumerWidget {
  const ContributorApplicationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => const ContributorApplicationSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref.watch(myContributorApplicationStreamProvider);
    final action = ref.watch(contributorRequestActionProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Pengajuan Kontributor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Flexible(
            child: application.when(
              loading: () => const Center(child: CircularProgressIndicator()),

              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Terjadi kesalahan: $error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              data: (requests) {
                if (requests.isEmpty) {
                  return ContributorProfileForm(
                    action: action,
                    buttonText: 'Ajukan Kontributor',
                  );
                }

                final request = requests.first;

                switch (request.status) {
                  case ContributorRequestStatus.pending:
                    return const _PendingView();

                  case ContributorRequestStatus.approved:
                    return const _ApprovedView();

                  case ContributorRequestStatus.rejected:
                    return _RejectedView(request: request, action: action);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingView extends StatelessWidget {
  const _PendingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.hourglass_top_rounded,
                    size: 64,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Pengajuan sedang diproses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Terima kasih telah mengajukan diri sebagai '
                    'kontributor. Mohon menunggu persetujuan admin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),

        _BottomAction(label: 'Tutup', onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}

class _ApprovedView extends StatelessWidget {
  const _ApprovedView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 64, color: Colors.green),

                  const SizedBox(height: 20),

                  const Text(
                    'Pengajuan disetujui!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Selamat! Sekarang Anda adalah kontributor.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        _BottomAction(
          label: 'Kembali ke Profil',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _RejectedView extends StatelessWidget {
  final ContributorRequest request;
  final AsyncValue action;

  const _RejectedView({required this.request, required this.action});

  @override
  Widget build(BuildContext context) {
    final canReapply = request.canReapply;
    final deadline = request.canReapplyAt;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cancel_outlined,
                          size: 64,
                          color: Colors.red,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Pengajuan ditolak',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (request.rejectionReason != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            request.rejectionReason!,
                            textAlign: TextAlign.center,
                          ),
                        ],

                        const SizedBox(height: 16),

                        Text(
                          canReapply
                              ? 'Anda sudah dapat mengajukan kembali.'
                              : 'Anda dapat mengajukan kembali pada '
                                    '${deadline != null ? DateFormat('dd-MM-yyyy HH:mm').format(deadline.toLocal()) : '-'}',
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        if (canReapply)
                          ContributorProfileForm(
                            action: action,
                            buttonText: 'Ajukan Kembali',
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _BottomAction(
          label: 'Kembali ke Profil',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _BottomAction({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        child: AppButton(
          label: label,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textColor: AppColors.white,
          borderColor: AppColors.primary,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
