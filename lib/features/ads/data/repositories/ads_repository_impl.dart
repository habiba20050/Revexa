import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/ads/data/datasources/ads_remote_datasource.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';
import 'package:revexa/features/ads/domain/repositories/ads_repository.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource _remote;

  AdsRepositoryImpl(this._remote);

  @override
  Future<Result<List<AdEntity>>> getAds() async {
    try {
      final ads = await _remote.getAds();
      return Success(ads);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<AdEntity>> createAd({
    required String title,
    required String imageUrl,
    String? description,
    String? actionUrl,
  }) async {
    try {
      final ad = await _remote.createAd(
        title: title,
        imageUrl: imageUrl,
        description: description,
        actionUrl: actionUrl,
      );
      return Success(ad);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<AdEntity>> updateAd(
    String id, {
    String? title,
    String? imageUrl,
    String? description,
    String? actionUrl,
    bool? isActive,
  }) async {
    try {
      final ad = await _remote.updateAd(
        id,
        title: title,
        imageUrl: imageUrl,
        description: description,
        actionUrl: actionUrl,
        isActive: isActive,
      );
      return Success(ad);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteAd(String id) async {
    try {
      await _remote.deleteAd(id);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<String>> uploadImage(String filePath) async {
    try {
      final url = await _remote.uploadImage(filePath);
      return Success(url);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }
}
