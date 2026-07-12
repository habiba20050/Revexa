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
  final String? location;
  final String? companyId;

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
    this.location,
    this.companyId,
  });

  static String _parseCategory(dynamic value) {
    if (value == null) return '';
    if (value is Map) {
      return value['_id']?.toString() ?? value['id']?.toString() ?? '';
    }
    return value.toString();
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: _parseCategory(json['category']),
      image: _readImageUrl(json),
      duration: (json['duration'] as num?)?.toInt() ?? 30,
      status: json['status']?.toString() ?? 'active',
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: (json['reviewsCount'] as num?)?.toInt(),
      location: json['location']?.toString(),
      companyId: json['companyId']?.toString(),
    );
  }

  static String? _readImageUrl(Map<String, dynamic> json) {
    final direct = ImageUrlUtils.resolve(json['image']);
    if (direct != null && direct.isNotEmpty) return direct;
    final images = json['images'];
    if (images is List && images.isNotEmpty) {
      // Check if it's a map containing url or just a direct string
      final firstImage = images.first;
      if (firstImage is Map) {
        final resolved = ImageUrlUtils.resolve(firstImage['url']);
        if (resolved != null && resolved.isNotEmpty) return resolved;
      } else {
        final resolved = ImageUrlUtils.resolve(firstImage);
        if (resolved != null && resolved.isNotEmpty) return resolved;
      }
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
    'location': location,
    'companyId': companyId,
  };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        category,
        image,
        duration,
        status,
        rating,
        reviewsCount,
        location,
        companyId,
      ];
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
