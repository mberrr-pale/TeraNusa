import 'package:flutter/material.dart';

import '../../domain/entities/opportunity_review.dart';

class OpportunityReviewSheet extends StatefulWidget {
  final OpportunityReview opportunity;
  final bool isLoading;

  final Future<void> Function(OpportunityReviewStatus status, String note)
  onSubmit;

  const OpportunityReviewSheet({
    super.key,
    required this.opportunity,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<OpportunityReviewSheet> createState() => _OpportunityReviewSheetState();
}

class _OpportunityReviewSheetState extends State<OpportunityReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  OpportunityReviewStatus _selectedStatus = OpportunityReviewStatus.approved;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.opportunity.reviewNote ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final note = _noteController.text.trim();

    try {
      await widget.onSubmit(_selectedStatus, note);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan keputusan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTakedown = _selectedStatus == OpportunityReviewStatus.takenDown;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Review Peluang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 16),

                Text(
                  widget.opportunity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Keputusan Review',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                RadioGroup<OpportunityReviewStatus>(
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    if (value != null && !widget.isLoading) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<OpportunityReviewStatus>(
                        value: OpportunityReviewStatus.approved,
                        title: const Text('Dismissed / Tidak Melanggar'),
                        subtitle: const Text(
                          'Laporan tidak terbukti. '
                          'Peluang tetap ditampilkan kepada pengguna.',
                        ),
                        activeColor: Colors.green,
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<OpportunityReviewStatus>(
                        value: OpportunityReviewStatus.takenDown,
                        title: const Text('Takedown Peluang'),
                        subtitle: const Text(
                          'Laporan terbukti. Peluang dinonaktifkan '
                          'dan tidak ditampilkan kepada pengguna.',
                        ),
                        activeColor: Colors.red,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                if (isTakedown)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Peluang akan dinonaktifkan dan '
                            'tidak lagi ditampilkan kepada pengguna.',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                Text(
                  isTakedown ? 'Alasan Takedown' : 'Catatan Admin',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _noteController,
                  enabled: !widget.isLoading,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Catatan wajib diisi.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: isTakedown
                        ? 'Tuliskan alasan takedown peluang...'
                        : 'Tuliskan alasan dismissed...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorMaxLines: 2,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTakedown ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: widget.isLoading ? null : _submit,
                    child: widget.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isTakedown
                                ? 'Konfirmasi Takedown'
                                : 'Konfirmasi Dismissed',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
