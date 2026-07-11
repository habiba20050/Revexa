import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';
import 'package:revexa/features/ads/domain/repositories/ads_repository.dart';

class CreateAdUseCase {
  final AdsRepository _repository;

  CreateAdUseCase(this._repository);

  Future<Result<AdEntity>> call({
    required String title,
    required String imageUrl,
    String? description,
    String? actionUrl,
  }) async {
    return await _repository.createAd(
      title: title,
      imageUrl: imageUrl,
      description: description,
      actionUrl: actionUrl,
    );
  }
}
