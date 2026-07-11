import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';

abstract interface class AdsRepository {
  Future<Result<List<AdEntity>>> getAds();
  Future<Result<AdEntity>> createAd({
    required String title,
    required String imageUrl,
    String? description,
    String? actionUrl,
  });
  Future<Result<AdEntity>> updateAd(
    String id, {
    String? title,
    String? imageUrl,
    String? description,
    String? actionUrl,
    bool? isActive,
  });
  Future<Result<void>> deleteAd(String id);
  Future<Result<String>> uploadImage(String filePath);
}
