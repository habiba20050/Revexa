import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  final String url;
  final String publicId;

  const ProductImage({required this.url, required this.publicId});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url']?.toString() ?? '',
      publicId: json['public_id']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [url, publicId];
}

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? category;
  final List<ProductImage> images;
  final String? location;
  final String? companyId;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.category,
    required this.images,
    this.location,
    this.companyId,
  });

  String get firstImageUrl => images.isNotEmpty ? images.first.url : '';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      location: json['location']?.toString(),
      companyId: json['companyId']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, title, description, price, category, images, location, companyId];
}

class ProductsPage extends Equatable {
  final List<Product> products;
  final int totalProducts;
  final int totalPages;
  final int currentPage;

  const ProductsPage({
    required this.products,
    required this.totalProducts,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [products, totalProducts, totalPages, currentPage];
}
