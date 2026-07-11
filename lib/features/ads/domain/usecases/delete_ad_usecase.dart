import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/ads/domain/repositories/ads_repository.dart';

class DeleteAdUseCase {
  final AdsRepository _repository;

  DeleteAdUseCase(this._repository);

  Future<Result<void>> call(String id) async {
    return await _repository.deleteAd(id);
  }
}
