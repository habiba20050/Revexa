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
  /// Returns a Result containing a map with `url` and `public_id`.
  Future<Result<Map<String, String>>> uploadImage(String filePath, {String? folder});
  Future<Result<Map<String, String>>> uploadImageBytes(List<int> bytes, {String fileName, String? folder});
}
