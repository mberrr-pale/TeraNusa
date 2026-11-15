import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import '../../core/widgets/opportunity_card.dart';
import '../../core/widgets/states/app_loading.dart';
import '../../core/widgets/states/app_error.dart';
import '../../core/widgets/states/app_empty.dart';
import '../../data/repositories/opportunity_repository.dart';
import '../../data/models/opportunity.dart';
import '../../core/widgets/app_dialog.dart';

class OpportunityPage extends StatefulWidget {
  const OpportunityPage({super.key});

  @override
  State<OpportunityPage> createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  final OpportunityRepository _repository = OpportunityRepository(
    Supabase.instance.client,
  );
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Opportunity>> _opportunitiesFuture;

  @override
  void initState() {
    super.initState();
    _opportunitiesFuture = _repository.searchOpportunities('');
  }

  void _searchOpportunities(String query) {
    setState(() {
      _opportunitiesFuture = _repository.searchOpportunities(query);
    });
  }

  Future<void> _refreshOpportunities() async {
    final future = _repository.searchOpportunities(_searchController.text);

    setState(() {
      _opportunitiesFuture = future;
    });

    await future;
  }

  void _showPageInfo(String title, String message) {
    AppDialog.show(context, title: title, message: message);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 18, 17, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Temukan Peluang', style: AppTextStyles.pageTitle),
                        const SizedBox(height: 5),
                        Text(
                          'Jelajahi berbagai peluang di sekitarmu.',
                          style: AppTextStyles.secondary,
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _searchController,
                          onChanged: _searchOpportunities,
                          decoration: InputDecoration(
                            hintText: 'Cari peluang...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _searchController.clear();
                                      _searchOpportunities('');
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: FutureBuilder<List<Opportunity>>(
                      future: _opportunitiesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const AppLoading(message: 'Memuat peluang...');
                        }

                        if (snapshot.hasError) {
                          return AppError(
                            message: 'Gagal memuat peluang.',
                            onRetry: () {
                              _searchOpportunities(_searchController.text);
                            },
                          );
                        }

                        final opportunities = snapshot.data ?? [];

                        if (opportunities.isEmpty) {
                          return AppEmpty(
                            title: 'Peluang tidak ditemukan',
                            description: _searchController.text.isEmpty
                                ? 'Belum ada peluang yang tersedia.'
                                : 'Coba gunakan kata kunci pencarian lainnya.',
                            icon: Icons.search_off_rounded,
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_searchController.text.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  17,
                                  4,
                                  17,
                                  12,
                                ),
                                child: Text(
                                  '${opportunities.length} peluang ditemukan',
                                  style: AppTextStyles.secondary.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: _refreshOpportunities,
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    17,
                                    0,
                                    17,
                                    16,
                                  ),
                                  itemCount: opportunities.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final opportunity = opportunities[index];

                                    return OpportunityCard(
                                      opportunity: opportunity,
                                      regionName:
                                          opportunity.regionName ??
                                          'Wilayah tidak diketahui',
                                      onTap: () {
                                        _showPageInfo(
                                          'Detail Peluang',
                                          'Halaman detail peluang sedang dalam tahap pengembangan.',
                                        );
                                      },
                                      onBookmarkTap: () {
                                        _showPageInfo(
                                          'Simpan Peluang',
                                          'Fitur menyimpan peluang sedang dalam tahap pengembangan.',
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }
}
