import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';
import 'package:revexa/features/ads/domain/repositories/ads_repository.dart';

class GetAdsUseCase {
  final AdsRepository _repository;

  GetAdsUseCase(this._repository);

  Future<Result<List<AdEntity>>> call() async {
    return await _repository.getAds();
  }
}
