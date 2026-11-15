import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import '../../core/widgets/news_card.dart';
import '../../core/widgets/states/app_loading.dart';
import '../../core/widgets/states/app_error.dart';
import '../../core/widgets/states/app_empty.dart';
import '../../core/widgets/app_dialog.dart';
import '../../data/models/news.dart';
import '../../data/repositories/news_repository.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsRepository _repository = NewsRepository(Supabase.instance.client);

  final TextEditingController _searchController = TextEditingController();

  late Future<List<News>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _repository.searchNews('');
  }

  void _searchNews(String query) {
    setState(() {
      _newsFuture = _repository.searchNews(query);
    });
  }

  Future<void> _refreshNews() async {
    final future = _repository.searchNews(_searchController.text);

    setState(() {
      _newsFuture = future;
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
                                        _showPageInfo(
                                          'Detail Berita',
                                          'Halaman detail berita sedang dalam tahap pengembangan.',
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

            const AppBottomNavigation(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}
