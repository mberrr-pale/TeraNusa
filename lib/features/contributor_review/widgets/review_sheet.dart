import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_dialog.dart';
import '../models/contributor_application.dart';
import 'status_badge.dart';

/// Membuka bottom sheet tinjau pengajuan kontributor / admin wilayah
/// (selaras dengan referensi desain tinjaudata.png).
/// Mengembalikan [ApplicationStatus] yang dipilih bila berhasil disimpan,
/// atau `null` bila sheet ditutup tanpa menyimpan.
Future<ApplicationStatus?> showReviewSheet(
  BuildContext context, {
  required ContributorApplication application,
  required Future<void> Function(ApplicationStatus status, String? note)
  onSubmit,
}) {
  return showModalBottomSheet<ApplicationStatus>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.84,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => _ReviewSheet(
        application: application,
        onSubmit: onSubmit,
        scrollController: scrollController,
      ),
    ),
  );
}

class _ReviewSheet extends StatefulWidget {
  final ContributorApplication application;
  final Future<void> Function(ApplicationStatus status, String? note) onSubmit;
  final ScrollController scrollController;

  const _ReviewSheet({
    required this.application,
    required this.onSubmit,
    required this.scrollController,
  });

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  late final TextEditingController _noteController;
  bool _showNoteField = false;
  bool _submitting = false;
  String? _noteError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    final existingNote = widget.application.adminNote?.trim() ?? '';
    _noteController = TextEditingController(text: existingNote);
    _showNoteField = existingNote.isNotEmpty;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<bool?> _confirm(ApplicationStatus status) {
    final name = widget.application.fullName;
    final roleTarget =
        widget.application.category == ApplicationCategory.regionalAdmin
        ? 'admin wilayah'
        : 'kontributor';
    final (title, body, dialogType) = switch (status) {
      ApplicationStatus.approved => (
        'Setujui pengajuan?',
        '$name akan disetujui sebagai $roleTarget.',
        AppDialogType.confirm,
      ),
      ApplicationStatus.rejected => (
        'Tolak pengajuan?',
        'Pengajuan $name akan ditolak dengan alasan yang kamu tulis.',
        AppDialogType.error,
      ),
      ApplicationStatus.pending => (
        'Tandai tetap menunggu?',
        'Pengajuan $name tetap berstatus Menunggu dan catatanmu disimpan.',
        AppDialogType.warning,
      ),
    };

    return AppDialog.show(
      context,
      title: title,
      message: body,
      type: dialogType,
      confirmLabel: 'Ya, lanjut',
      cancelLabel: 'Batal',
    );
  }

  Future<void> _handle(ApplicationStatus status) async {
    if (_submitting) return;

    final note = _noteController.text.trim();

    if (status == ApplicationStatus.rejected && note.isEmpty) {
      setState(() {
        _showNoteField = true;
        _noteError = 'Alasan penolakan wajib diisi';
      });
      return;
    }

    setState(() {
      _noteError = null;
      _submitError = null;
    });

    final ok = await _confirm(status);
    if (ok != true || !mounted) return;

    setState(() => _submitting = true);
    try {
      await widget.onSubmit(status, note.isEmpty ? null : note);
      if (!mounted) return;
      Navigator.pop(context, status);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError = 'Gagal menyimpan keputusan. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final isPending = app.status == ApplicationStatus.pending;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
        children: [
          // Handle bar
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
          const SizedBox(height: 10),

          // Header terpusat + tombol tutup bulat di kanan atas
          SizedBox(
            height: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 42),
                  child: Text(
                    'Tinjau Data Pengajuan',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: IconButton(
                      onPressed: _submitting
                          ? null
                          : () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: 'Tutup',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Profil pemohon terpusat (selaras tinjaudata.png)
          Center(
            child: Container(
              width: 68,
              height: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                app.initials,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            app.fullName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${app.roleLabel} · ${app.position}',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 12),

          // Status badge + waktu kirim sejajar di tengah
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              StatusBadge(status: app.status),
              Text(
                formatSubmittedAt(app.submittedAt),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // DATA PENGAJUAN: READ-ONLY (murni Text, tanpa mode edit)
          const _SectionCaption('PENGAJUAN'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KeyValueRow(label: 'Instansi', value: app.institution),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border.withValues(alpha: 0.75),
                ),
                _KeyValueRow(label: 'Wilayah', value: app.region),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border.withValues(alpha: 0.75),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alasan',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        app.reason,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppColors.heading,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // DATA KONTAK: READ-ONLY
          const _SectionCaption('KONTAK'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _KeyValueRow(label: 'Email', value: app.email),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border.withValues(alpha: 0.75),
                ),
                _KeyValueRow(label: 'No. HP', value: app.phone),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (isPending) ...[
            if (app.reviewedAt != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: ApplicationStatus.pending.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: ApplicationStatus.pending.color,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Terakhir ditinjau ${formatSubmittedAt(app.reviewedAt!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: ApplicationStatus.pending.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Toggle "+ Tambah catatan (opsional)" sesuai tinjaudata.png
            Center(
              child: TextButton(
                key: const Key('toggle_admin_note_button'),
                onPressed: _submitting
                    ? null
                    : () => setState(() {
                        _showNoteField = !_showNoteField;
                        if (!_showNoteField) {
                          _noteError = null;
                        }
                      }),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  _showNoteField
                      ? 'Sembunyikan catatan'
                      : '+ Tambah catatan (opsional)',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            if (_showNoteField) ...[
              const SizedBox(height: 6),
              TextField(
                controller: _noteController,
                enabled: !_submitting,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tulis catatan admin (wajib diisi bila menolak)',
                  errorText: _noteError,
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],

            if (_submitError != null) ...[
              const SizedBox(height: 8),
              Text(
                _submitError!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ApplicationStatus.rejected.color,
                ),
              ),
            ],
            const SizedBox(height: 14),

            // 3 Tombol pill sejajar: Tolak | Pending | Setujui (selaras tinjaudata.png)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _ReviewPillButton(
                    key: const Key('review_action_reject'),
                    label: 'Tolak',
                    backgroundColor: const Color(0xFFFBEAEA),
                    foregroundColor: ApplicationStatus.rejected.color,
                    onPressed: _submitting
                        ? null
                        : () => _handle(ApplicationStatus.rejected),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: _ReviewPillButton(
                    key: const Key('review_action_pending'),
                    label: 'Pending',
                    backgroundColor: const Color(0xFFFFEFE0),
                    foregroundColor: ApplicationStatus.pending.color,
                    onPressed: _submitting
                        ? null
                        : () => _handle(ApplicationStatus.pending),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: _ReviewPillButton(
                    key: const Key('review_action_approve'),
                    label: 'Setujui',
                    backgroundColor: ApplicationStatus.approved.color,
                    foregroundColor: AppColors.white,
                    elevated: true,
                    onPressed: _submitting
                        ? null
                        : () => _handle(ApplicationStatus.approved),
                  ),
                ),
              ],
            ),

            if (_submitting) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ] else ...[
            // Sudah diputuskan: tampilkan informasi saja tanpa tombol aksi
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: app.status.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: app.status.color.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(app.status.icon, size: 18, color: app.status.color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pengajuan ini sudah ${app.status.label.toLowerCase()}.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: app.status.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (app.reviewedAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Ditinjau: ${formatSubmittedAt(app.reviewedAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: app.status.color.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                  if (app.adminNote != null &&
                      app.adminNote!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Catatan: ${app.adminNote}',
                      style: TextStyle(fontSize: 12, color: app.status.color),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCaption extends StatelessWidget {
  final String text;

  const _SectionCaption(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.secondaryText,
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
              value,
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
}

class _ReviewPillButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool elevated;
  final VoidCallback? onPressed;

  const _ReviewPillButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.elevated = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final effectiveBg = disabled
        ? backgroundColor.withValues(alpha: 0.55)
        : backgroundColor;
    final effectiveFg = disabled
        ? foregroundColor.withValues(alpha: 0.55)
        : foregroundColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: elevated && !disabled
            ? [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.22),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 48,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: effectiveFg,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
