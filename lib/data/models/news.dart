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

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['news_id'].toString(),
      title: map['title'].toString(),
      summary: map['summary'].toString(),
      source: map['source'].toString(),
      sourceUrl: map['source_url'].toString(),
      imageUrl: map['image_url']?.toString() ?? '',
      regionId: map['region_id'].toString(),
      publishedAt: DateTime.parse(map['published_at'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'news_id': id,
      'title': title,
      'summary': summary,
      'source': source,
      'source_url': sourceUrl,
      'image_url': imageUrl,
      'region_id': regionId,
      'published_at': publishedAt.toIso8601String(),
    };
  }
}
