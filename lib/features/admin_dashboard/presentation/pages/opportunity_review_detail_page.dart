import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_header.dart';

import '../../domain/entities/opportunity_review.dart';
import '../../domain/entities/opportunity_report.dart';
import '../../domain/repositories/opportunity_review_repository.dart';

import '../providers/opportunity_review_provider.dart';
import '../widgets/opportunity_report_list.dart';
import '../widgets/opportunity_review_sheet.dart';
import '../widgets/opportunity_review_status_badge.dart';

class OpportunityReviewDetailPage extends ConsumerStatefulWidget {
  final String opportunityId;

  const OpportunityReviewDetailPage({super.key, required this.opportunityId});

  @override
  ConsumerState<OpportunityReviewDetailPage> createState() =>
      _OpportunityReviewDetailPageState();
}

class _OpportunityReviewDetailPageState
    extends ConsumerState<OpportunityReviewDetailPage> {
  OpportunityReview? _opportunity;
  List<OpportunityReport> _reports = [];

  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final repository = ref.read(opportunityReviewRepositoryProvider);

      final opportunity = await repository.getOpportunityReviewDetail(
        widget.opportunityId,
      );

      final reports = await repository.getOpportunityReports(
        opportunity.opportunityId,
      );

      if (!mounted) return;

      setState(() {
        _opportunity = opportunity;
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _startReview() async {
    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(opportunityReviewControllerProvider)
          .startReview(widget.opportunityId);

      await _loadData();
    } catch (e) {
      debugPrint('Gagal memulai review: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memulai review: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _submitDecision(
    OpportunityReviewStatus status,
    String note,
  ) async {
    final opportunity = _opportunity;

    if (opportunity == null) return;

    await ref
        .read(opportunityReviewControllerProvider)
        .submitReview(
          opportunityId: opportunity.opportunityId,
          status: status,
          note: note,
        );
  }

  Future<void> _openReviewSheet() async {
    final opportunity = _opportunity;

    if (opportunity == null) return;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return OpportunityReviewSheet(
          opportunity: opportunity,
          isLoading: _isSubmitting,
          onSubmit: (status, note) async {
            setState(() => _isSubmitting = true);

            try {
              await _submitDecision(status, note);
            } finally {
              if (mounted) {
                setState(() => _isSubmitting = false);
              }
            }
          },
        );
      },
    );

    if (result == true && mounted) {
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keputusan review berhasil disimpan.')),
        );
      }
    }
  }

  Future<void> _openReportDetail(OpportunityReport report) async {
    final noteController = TextEditingController(text: report.adminNote ?? '');

    ReportStatus selectedStatus = report.status;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Detail Laporan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.reason,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(report.description ?? 'Tidak ada deskripsi.'),
                    const SizedBox(height: 16),
                    const Text('Status Laporan'),
                    DropdownButton<ReportStatus>(
                      isExpanded: true,
                      value: selectedStatus,
                      items: ReportStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Catatan Admin',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(opportunityReviewControllerProvider)
                          .changeReportStatus(
                            reportId: report.reportId,
                            status: selectedStatus,
                            adminNote: noteController.text.trim(),
                          );

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext, true);
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        ScaffoldMessenger.of(dialogContext)
                            .showSnackBar(SnackBar(content: Text('Gagal: $e')));
                      }
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    noteController.dispose();

    if (result == true && mounted) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader.backTitle(title: 'Detail Review Peluang'),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Gagal memuat detail peluang.'),
            TextButton(onPressed: _loadData, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    final opportunity = _opportunity;

    if (opportunity == null) {
      return const Center(child: Text('Data peluang tidak ditemukan.'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            opportunity.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          OpportunityReviewStatusBadge(status: opportunity.reviewStatus),

          const SizedBox(height: 16),

          Text(opportunity.description),

          const SizedBox(height: 20),

          _buildInformation('Kategori', opportunity.category),

          _buildInformation('Status Peluang', opportunity.status),

          _buildInformation(
            'Total laporan',
            opportunity.reportCount.toString(),
          ),

          _buildInformation(
            'Laporan baru',
            opportunity.newReportCount.toString(),
          ),

          _buildInformation(
            'Siklus review',
            opportunity.reviewCycle.toString(),
          ),

          if (opportunity.reviewNote != null)
            _buildInformation(
              'Catatan review sebelumnya',
              opportunity.reviewNote!,
            ),

          const SizedBox(height: 20),

          const Text(
            'Daftar Laporan Pengguna',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),

          const SizedBox(height: 12),

          OpportunityReportList(reports: _reports, onTap: _openReportDetail),

          const SizedBox(height: 20),

          if (opportunity.reviewStatus == OpportunityReviewStatus.pendingReview)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _startReview,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Mulai Review'),
              ),
            ),

          if (opportunity.reviewStatus == OpportunityReviewStatus.underReview)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _openReviewSheet,
                child: const Text('Berikan Keputusan'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInformation(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
