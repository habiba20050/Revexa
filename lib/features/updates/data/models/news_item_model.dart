import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? articleUrl;
  final String? sourceName;
  final DateTime? publishedAt;

  const NewsItem({
    required this.id,
    required this.title,
    this.description = '',
    this.imageUrl,
    this.articleUrl,
    this.sourceName,
    this.publishedAt,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final publishedAtRaw = json['publishedAt'] ?? json['createdAt'];
    DateTime? publishedAt;
    if (publishedAtRaw is String && publishedAtRaw.isNotEmpty) {
      publishedAt = DateTime.tryParse(publishedAtRaw);
    } else if (publishedAtRaw is DateTime) {
      publishedAt = publishedAtRaw;
    }

    final articleUrl = json['url']?.toString();
    final id = json['_id']?.toString() ??
        json['id']?.toString() ??
        articleUrl ??
        json['title']?.toString() ??
        '';

    return NewsItem(
      id: id,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['urlToImage']?.toString() ??
          json['image']?.toString() ??
          json['imageUrl']?.toString(),
      articleUrl: articleUrl,
      sourceName: json['sourceName']?.toString() ?? json['source']?.toString(),
      publishedAt: publishedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, imageUrl, articleUrl, sourceName, publishedAt];
}

class NewsPage extends Equatable {
  final List<NewsItem> items;
  final int total;
  final int currentPage;
  final int totalPages;

  const NewsPage({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
  });

  factory NewsPage.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final list = data is List
        ? data
            .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
            .toList()
        : <NewsItem>[];

    return NewsPage(
      items: list,
      total: (json['total'] as num?)?.toInt() ?? list.length,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  @override
  List<Object?> get props => [items, total, currentPage, totalPages];
}
