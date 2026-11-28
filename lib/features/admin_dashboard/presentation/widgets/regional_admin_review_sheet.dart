import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/contributor.dart';
import '../../../region/presentation/providers/region_provider.dart';

/// Bottom sheet untuk meninjau calon Admin Wilayah.
Future<bool?> showRegionalAdminReviewSheet(
  BuildContext context, {
  required Contributor contributor,
  required Future<void> Function() onSubmit,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.50,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => _RegionalAdminReviewSheet(
        contributor: contributor,
        onSubmit: onSubmit,
        scrollController: scrollController,
      ),
    ),
  );
}

class _RegionalAdminReviewSheet extends ConsumerStatefulWidget {
  final Contributor contributor;
  final Future<void> Function() onSubmit;
  final ScrollController scrollController;

  const _RegionalAdminReviewSheet({
    required this.contributor,
    required this.onSubmit,
    required this.scrollController,
  });

  @override
  ConsumerState<_RegionalAdminReviewSheet> createState() =>
      _RegionalAdminReviewSheetState();
}

class _RegionalAdminReviewSheetState
    extends ConsumerState<_RegionalAdminReviewSheet> {
  bool _submitting = false;
  String _region = 'Memuat wilayah...';

  @override
  void initState() {
    super.initState();
    _loadRegion();
  }

  Future<void> _loadRegion() async {
    final regionId = widget.contributor.regionId?.trim() ?? '';

    if (regionId.isEmpty) {
      if (!mounted) return;

      setState(() {
        _region = 'Wilayah belum ditentukan';
      });
      return;
    }

    try {
      final result = await ref.read(getRegionByIdProvider(regionId).future);

      if (!mounted) return;

      if (result == null) {
        setState(() {
          _region = 'Wilayah tidak ditemukan';
        });
        return;
      }

      final parts = [
        result.village,
        result.district,
        result.city,
        result.province,
      ].where((value) => value.trim().isNotEmpty);

      setState(() {
        _region = parts.join(', ').isEmpty
            ? 'Wilayah tidak ditemukan'
            : parts.join(', ');
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _region = 'Gagal memuat wilayah';
      });
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;

    setState(() => _submitting = true);

    try {
      await widget.onSubmit();

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      setState(() => _submitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menjadikan Admin Wilayah: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contributor = widget.contributor;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Tinjau Calon Admin Wilayah',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                contributor.name.isNotEmpty
                    ? contributor.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            contributor.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.heading,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _info('Nama', contributor.name),
                const Divider(),

                _info('Email', contributor.email),
                const Divider(),

                _info('No. HP', contributor.phone ?? '-'),
                const Divider(),

                _info('Wilayah', _region),
                const Divider(),
                _info(
                  'Role saat ini',
                  contributor.isContributor ? 'Kontributor' : contributor.role,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Apakah kamu yakin ingin menjadikan akun ini '
            'sebagai Admin Wilayah?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.secondaryText,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.pop(context, false),
                  child: const Text('Tutup'),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
