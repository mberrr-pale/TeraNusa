import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/opportunity_card.dart';
import '../../data/local/dummy_opportunities.dart';
import '../../data/models/opportunity.dart';
import '../../data/repositories/opportunity_repository.dart';
import '../../core/widgets/states/app_loading.dart';
import '../../core/widgets/states/app_error.dart';
import '../../core/widgets/states/app_empty.dart';
import '../../core/widgets/news_card.dart';
import '../../data/local/dummy_news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OpportunityRepository _repository = OpportunityRepository();

  late Future<List<Opportunity>> _opportunitiesFuture;

  @override
  void initState() {
    super.initState();
    _opportunitiesFuture = _repository.getFeedOpportunities();
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _opportunitiesFuture = _repository.getFeedOpportunities();
    });

    await _opportunitiesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // REUSABLE HEADER (TETAP)
            const AppHeader(),

            // KONTEN FEED (SCROLLABLE)
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refreshFeed,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 15, 14, 0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildRegionBanner(),
                          const SizedBox(height: 11),
                          _buildGuestCard(),
                          const SizedBox(height: 22),
                          _buildSectionHeader(),
                          const SizedBox(height: 11),
                        ]),
                      ),
                    ),

                    // OPPORTUNITY LIST
                    _buildOpportunityList(),

                    // LOCAL NEWS
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 20, 14, 20),
                        child: _buildLocalNewsSection(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // REGION BANNER

  Widget _buildRegionBanner() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 185),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.bannerStart, AppColors.bannerEnd],
        ),
        border: Border.all(color: AppColors.bannerStart),
        borderRadius: BorderRadius.circular(22),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize = constraints.maxWidth < 320 ? 68.0 : 85.0;

          final textWidth = (constraints.maxWidth - iconSize - 15).clamp(
            0.0,
            270.0,
          );

          return Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 5,
                child: Transform.rotate(
                  angle: -0.14,
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.35),
                        width: 10,
                      ),
                    ),
                    child: Icon(
                      Icons.place_outlined,
                      color: AppColors.primary,
                      size: iconSize * 0.45,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'JELAJAHI WILAYAH',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      'Peluang baik ada di sekitar kita.',
                      style: AppTextStyles.pageTitle.copyWith(
                        fontSize: 24,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      'Temukan informasi lokal tepercaya, '
                      'dari warga untuk warga.',
                      style: AppTextStyles.secondary.copyWith(
                        color: AppColors.bannerText,
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // GUEST INFORMATION

  Widget _buildGuestCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.empowermentBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: 19,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kamu sedang menjelajah sebagai tamu',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 9),
                ),
                const SizedBox(height: 3),
                Text(
                  'Masuk untuk menyimpan dan berkontribusi',
                  style: AppTextStyles.secondary.copyWith(fontSize: 8),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Informasi'),
                    content: const Text(
                      'Fitur login masih dalam tahap pengembangan.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Mengerti'),
                      ),
                    ],
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Masuk',
              style: AppTextStyles.button.copyWith(
                color: AppColors.primary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION HEADER

  Widget _buildSectionHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Peluang terbaru', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 3),
              Text(
                'Informasi peluang yang masih berlaku',
                style: AppTextStyles.secondary.copyWith(fontSize: 9),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: const Text('Informasi'),
                  content: const Text(
                    'Halaman Kategori sedang dalam tahap pengembangan.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text('Mengerti'),
                    ),
                  ],
                );
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lihat semua',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right,
                color: AppColors.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // OPPORTUNITY LIST

  Widget _buildOpportunityList() {
    return FutureBuilder<List<Opportunity>>(
      future: _opportunitiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: AppLoading(message: 'Memuat peluang...'),
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AppError(
                message: 'Gagal memuat peluang.',
                onRetry: () {
                  setState(() {
                    _opportunitiesFuture = _repository.getFeedOpportunities();
                  });
                },
              ),
            ),
          );
        }

        final opportunities = snapshot.data ?? [];

        if (opportunities.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: AppEmpty(
                title: 'Belum ada peluang',
                message: 'Peluang baru akan muncul di sini.',
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final opportunity = opportunities[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: OpportunityCard(
                  opportunity: opportunity,
                  regionName:
                      dummyRegionNames[opportunity.regionId] ?? 'Wilayah lokal',
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Detail Peluang'),
                          content: const Text(
                            'Halaman detail peluang sedang '
                            'dalam tahap pengembangan.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Mengerti'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onBookmarkTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Simpan Peluang'),
                          content: const Text(
                            'Fitur menyimpan peluang sedang '
                            'dalam tahap pengembangan.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Mengerti'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            }, childCount: opportunities.length),
          ),
        );
      },
    );
  }

  // LOCAL NEWS

  Widget _buildLocalNewsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 10) / 2;
        final newsList = dummyNews.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kabar daerah', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 3),
                      Text(
                        'Berita pilihan dari sumber lokal.',
                        style: AppTextStyles.secondary.copyWith(fontSize: 9),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Berita'),
                          content: const Text(
                            'Halaman Berita sedang dalam tahap pengembangan.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Mengerti'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat semua',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // HORIZONTAL NEWS LIST
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: newsList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  final news = newsList[index];

                  return NewsCard(
                    news: news,
                    width: cardWidth,
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Detail Berita'),
                            content: const Text(
                              'Halaman detail berita sedang dalam tahap pengembangan.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const Text('Mengerti'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // BOTTOM NAVIGATION

  Widget _buildBottomNavigation() {
    void showPageInfo(String pageName) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(pageName),
            content: Text('Halaman $pageName sedang dalam tahap pengembangan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Mengerti'),
              ),
            ],
          );
        },
      );
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondaryText,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: (index) {
        switch (index) {
          case 0:
            // Sudah berada di halaman Beranda.
            break;
          case 1:
            showPageInfo('Kategori');
            break;
          case 2:
            showPageInfo('Tersimpan');
            break;
          case 3:
            showPageInfo('Profil');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: 'Kategori',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          label: 'Tersimpan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
