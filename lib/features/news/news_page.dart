import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/news.dart';
import '../../data/repositories/news_repository.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import '../../core/widgets/news_card.dart';
import '../../core/widgets/states/app_loading.dart';
import '../../core/widgets/states/app_error.dart';
import '../../core/widgets/states/app_empty.dart';
import '../../core/widgets/app_bottom_sheet.dart';
import '../../core/widgets/filter_summary_badge.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsRepository _repository = NewsRepository(Supabase.instance.client);

  final TextEditingController _searchController = TextEditingController();

  late Future<List<News>> _newsFuture;

  String _selectedCity = 'Semua wilayah';
  String _selectedSort = 'Terbaru';

  List<String> _availableCities = [];

  static const List<String> _sortOptions = ['Terbaru', 'Terlama'];

  @override
  void initState() {
    super.initState();
    _newsFuture = _getFilteredNews();
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
      debugPrint('Gagal memuat daftar kota berita: $error');
    }
  }

  Future<List<News>> _getFilteredNews() {
    return _repository.searchNews(
      _searchController.text,
      city: _selectedCity,
      sortBy: _selectedSort,
    );
  }

  void _searchNews(String query) {
    setState(() {
      _newsFuture = _getFilteredNews();
    });
  }

  Future<void> _refreshNews() async {
    final future = _getFilteredNews();

    setState(() {
      _newsFuture = future;
    });

    await future;
  }

  Future<void> _showFilterSheet() async {
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
      title: 'Filter berita',
      contentBuilder: (context, setSheetState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              _selectedCity = city;
              _selectedSort = sort;
              _newsFuture = _getFilteredNews();
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
                    padding: const EdgeInsets.fromLTRB(17, 20, 17, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Berita Lokal', style: AppTextStyles.pageTitle),
                        const SizedBox(height: 5),
                        Text(
                          'Temukan informasi dan kabar terbaru dari daerah.',
                          style: AppTextStyles.secondary,
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _searchController,
                          onChanged: _searchNews,
                          decoration: InputDecoration(
                            hintText: 'Cari berita...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _searchController.clear();
                                      _searchNews('');
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
                    child: FutureBuilder<List<News>>(
                      future: _newsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const AppLoading();
                        }

                        if (snapshot.hasError) {
                          return AppError(
                            message: 'Gagal memuat berita. Silakan coba lagi.',
                            onRetry: _refreshNews,
                          );
                        }

                        final newsList = snapshot.data ?? [];

                        if (newsList.isEmpty) {
                          return AppEmpty(
                            icon: Icons.newspaper_outlined,
                            title: 'Berita tidak ditemukan',
                            description: _searchController.text.trim().isEmpty
                                ? 'Belum ada berita yang tersedia.'
                                : 'Coba gunakan kata kunci pencarian lainnya.',
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
                                  '${newsList.length} berita ditemukan',
                                  style: AppTextStyles.secondary.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: _refreshNews,
                                child: GridView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    17,
                                    4,
                                    17,
                                    20,
                                  ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 14,
                                        mainAxisExtent: 205,
                                      ),
                                  itemCount: newsList.length,
                                  itemBuilder: (context, index) {
                                    return NewsCard(
                                      news: newsList[index],
                                      width: double.infinity,
                                      onTap: () {
                                        context.push(
                                          AppRoutes.newsDetail,
                                          extra: newsList[index],
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

            const AppBottomNavigation(),
          ],
        ),
      ),
    );
  }
}
