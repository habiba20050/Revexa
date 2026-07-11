import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';
import 'package:revexa/features/ads/domain/repositories/ads_repository.dart';

class UpdateAdUseCase {
  final AdsRepository _repository;

  UpdateAdUseCase(this._repository);

  Future<Result<AdEntity>> call(
    String id, {
    String? title,
    String? imageUrl,
    String? description,
    String? actionUrl,
    bool? isActive,
  }) async {
    return await _repository.updateAd(
      id,
      title: title,
      imageUrl: imageUrl,
      description: description,
      actionUrl: actionUrl,
      isActive: isActive,
    );
  }
}
