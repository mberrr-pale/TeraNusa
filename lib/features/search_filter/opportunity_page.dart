import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
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
import '../../core/widgets/app_bottom_sheet.dart';
import '../../core/widgets/filter_summary_badge.dart';

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

  String _selectedCategory = 'Semua';
  String _selectedCity = 'Semua wilayah';
  String _selectedSort = 'Terbaru';

  List<String> _availableCities = [];

  static const List<String> _categories = [
    'Semua',
    'Lowongan',
    'Event',
    'Pemberdayaan',
    'Produk & Jasa',
  ];

  static const List<String> _sortOptions = [
    'Terbaru',
    'Terlama',
    'Segera berakhir',
  ];

  late Future<List<Opportunity>> _opportunitiesFuture;

  @override
  void initState() {
    super.initState();
    _opportunitiesFuture = _getFilteredOpportunities();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await _repository.getAvailableCities();

      if (!mounted) return;

      setState(() {
        _availableCities = cities;
      });
    } catch (error) {
      debugPrint('Gagal memuat daftar kota: $error');
    }
  }

  Future<List<Opportunity>> _getFilteredOpportunities() {
    return _repository.searchOpportunities(
      _searchController.text,
      category: _selectedCategory,
      city: _selectedCity,
      sortBy: _selectedSort,
    );
  }

  void _searchOpportunities(String query) {
    setState(() {
      _opportunitiesFuture = _getFilteredOpportunities();
    });
  }

  Future<void> _refreshOpportunities() async {
    final future = _getFilteredOpportunities();

    setState(() {
      _opportunitiesFuture = future;
    });

    await future;
  }

  Future<void> _showFilterSheet() async {
    String category = _selectedCategory;
    String city = _selectedCity;
    String sort = _selectedSort;

    Widget optionGroup({
      required String title,
      required List<String> options,
      required String selected,
      required ValueChanged<String> onSelected,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF194D29),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              final isSelected = selected == option;

              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (_) => onSelected(option),
                selectedColor: const Color(0xFF19652A),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF19652A)
                      : const Color(0xFFDCEBDD),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF718579),
                  fontWeight: FontWeight.w600,
                ),
                shape: const StadiumBorder(),
              );
            }).toList(),
          ),
        ],
      );
    }

    await AppBottomSheet.show<void>(
      context: context,
      title: 'Filter peluang',
      contentBuilder: (context, setSheetState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            optionGroup(
              title: 'Kategori',
              options: _categories,
              selected: category,
              onSelected: (value) {
                setSheetState(() => category = value);
              },
            ),
            const SizedBox(height: 28),
            optionGroup(
              title: 'Wilayah',
              options: ['Semua wilayah', ..._availableCities],
              selected: city,
              onSelected: (value) {
                setSheetState(() => city = value);
              },
            ),
            const SizedBox(height: 28),
            optionGroup(
              title: 'Urutkan',
              options: _sortOptions,
              selected: sort,
              onSelected: (value) {
                setSheetState(() => sort = value);
              },
            ),
          ],
        );
      },
      action: SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF19652A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedCategory = category;
              _selectedCity = city;
              _selectedSort = sort;
              _opportunitiesFuture = _getFilteredOpportunities();
            });

            Navigator.pop(context);
          },
          child: const Text(
            'Terapkan Filter',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
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
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    FilterSummaryBadge.category(
                                      category: _selectedCategory == 'Semua'
                                          ? 'Semua'
                                          : _selectedCategory
                                                .toLowerCase()
                                                .replaceAll(' & ', '_'),
                                      label: _selectedCategory == 'Semua'
                                          ? 'Semua kategori'
                                          : _selectedCategory,
                                    ),
                                    const SizedBox(width: 6),
                                    FilterSummaryBadge.region(
                                      label: _selectedCity,
                                    ),
                                    const SizedBox(width: 6),
                                    FilterSummaryBadge.sort(
                                      label: _selectedSort,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: _showFilterSheet,
                              icon: const Icon(Icons.tune, size: 17),
                              label: const Text('Filter'),
                            ),
                          ],
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
                                        context.push(
                                          AppRoutes.opportunityDetail,
                                          extra: opportunity,
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
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }
}
