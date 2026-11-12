class News {
  final String id;
  final String title;
  final String summary;
  final String source;
  final String sourceUrl;
  final String imageUrl;
  final String regionId;
  final DateTime publishedAt;

  const News({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.sourceUrl,
    required this.imageUrl,
    required this.regionId,
    required this.publishedAt,
  });
}
