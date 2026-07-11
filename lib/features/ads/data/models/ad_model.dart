import 'package:revexa/core/utils/image_url_utils.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';

class AdModel extends AdEntity {
  const AdModel({
    required super.id,
    required super.title,
    super.description,
    required super.imageUrl,
    super.actionUrl,
    super.isActive,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: ImageUrlUtils.resolve(json['image'] ?? json['imageUrl'] ?? json['image_url']) ?? '',
      actionUrl: json['url']?.toString() ?? json['actionUrl']?.toString() ?? json['action_url']?.toString(),
      isActive: json['isActive'] as bool? ?? json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'isActive': isActive,
    };
  }
}
