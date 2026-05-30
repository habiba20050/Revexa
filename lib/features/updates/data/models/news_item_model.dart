import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime? publishedAt;

  const NewsItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.publishedAt,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final publishedAtRaw = json['publishedAt'] ?? json['createdAt'];
    DateTime? publishedAt;
    if (publishedAtRaw is String && publishedAtRaw.isNotEmpty) {
      publishedAt = DateTime.tryParse(publishedAtRaw);
    }

    return NewsItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['headline']?.toString() ?? '',
      description: json['description']?.toString() ?? json['body']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? json['imageUrl']?.toString(),
      publishedAt: publishedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, publishedAt];
}
