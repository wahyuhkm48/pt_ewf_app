class NewsArticle {
  final String articleId;
  final String title;
  final String? description;
  final String link;
  final String? imageUrl;
  final DateTime? pubDate;
  final String sourceName;
  final String? sourceIcon;
  final List<String> category;
  final List<String>? creator;

  NewsArticle({
    required this.articleId,
    required this.title,
    this.description,
    required this.link,
    this.imageUrl,
    this.pubDate,
    required this.sourceName,
    this.sourceIcon,
    this.category = const [],
    this.creator,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      articleId: json['article_id'] ?? '',
      title: json['title'] ?? 'Tanpa judul',
      description: json['description'],
      link: json['link'] ?? '',
      imageUrl: json['image_url'],
      pubDate: json['pubDate'] != null
          ? DateTime.tryParse(json['pubDate'])
          : null,
      sourceName: json['source_name'] ?? 'Tidak diketahui',
      sourceIcon: json['source_icon'],
      category: json['category'] != null
          ? List<String>.from(json['category'])
          : [],
      creator: json['creator'] != null
          ? List<String>.from(json['creator'])
          : null,
    );
  }
}