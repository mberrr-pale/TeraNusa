import 'package:flutter/material.dart';

import '../../domain/entities/opportunity_report.dart';
import 'opportunity_report_card.dart';

class OpportunityReportList extends StatelessWidget {
  final List<OpportunityReport> reports;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<OpportunityReport> onTap;

  const OpportunityReportList({
    super.key,
    required this.reports,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && reports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null && reports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Gagal memuat laporan.'),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    if (reports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('Belum ada laporan untuk peluang ini.')),
      );
    }

    return Column(
      children: reports.map((report) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OpportunityReportCard(
            report: report,
            onTap: () => onTap(report),
          ),
        );
      }).toList(),
    );
  }
}
