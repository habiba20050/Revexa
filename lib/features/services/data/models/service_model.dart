import 'package:equatable/equatable.dart';
import 'package:revexa/core/utils/image_url_utils.dart';

class Service extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? image;
  final int duration; // بالدقائق
  final String status; // active, inactive
  final double? rating;
  final int? reviewsCount;

  String get title => name;
  String get firstImageUrl => ImageUrlUtils.resolve(image) ?? '';

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.image,
    this.duration = 30,
    this.status = 'active',
    this.rating,
    this.reviewsCount,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? '',
      image: _readImageUrl(json),
      duration: (json['duration'] as num?)?.toInt() ?? 30,
      status: json['status']?.toString() ?? 'active',
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: (json['reviewsCount'] as num?)?.toInt(),
    );
  }

  static String? _readImageUrl(Map<String, dynamic> json) {
    final direct = ImageUrlUtils.resolve(json['image']);
    if (direct != null && direct.isNotEmpty) return direct;
    final images = json['images'];
    if (images is List && images.isNotEmpty) {
      final resolved = ImageUrlUtils.resolve(images.first);
      if (resolved != null && resolved.isNotEmpty) return resolved;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'category': category,
    'image': image,
    'duration': duration,
    'status': status,
  };

  @override
  List<Object?> get props => [id, name, description, price, category, image, duration, status, rating, reviewsCount];
}

class ServicesPage extends Equatable {
  final List<Service> services;
  final int totalServices;
  final int totalPages;
  final int currentPage;

  const ServicesPage({
    required this.services,
    required this.totalServices,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [services, totalServices, totalPages, currentPage];
}
