import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/ads/domain/repositories/ads_repository.dart';
import 'package:revexa/features/ads/domain/usecases/get_ads_usecase.dart';
import 'package:revexa/features/ads/domain/usecases/create_ad_usecase.dart';
import 'package:revexa/features/ads/domain/usecases/update_ad_usecase.dart';
import 'package:revexa/features/ads/domain/usecases/delete_ad_usecase.dart';
import 'package:revexa/features/ads/presentation/cubit/ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final GetAdsUseCase _getAdsUseCase;
  final CreateAdUseCase _createAdUseCase;
  final UpdateAdUseCase _updateAdUseCase;
  final DeleteAdUseCase _deleteAdUseCase;
  final AdsRepository _repository;

  AdsCubit(
    this._getAdsUseCase,
    this._createAdUseCase,
    this._updateAdUseCase,
    this._deleteAdUseCase,
    this._repository,
  ) : super(const AdsInitial());

  Future<void> loadAds() async {
    if (isClosed) return;
    emit(const AdsLoading());
    try {
      final result = await _getAdsUseCase();
      if (isClosed) return;
      
      switch (result) {
        case Success<dynamic>():
          emit(AdsLoaded((result as Success).value));
        case ResultFailure<dynamic>():
          emit(AdsError((result as ResultFailure).failure.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AdsError('Unexpected error occurred: $e'));
      }
    }
  }

  Future<void> createAd({
    required String title,
    required String imageUrl,
    String? description,
    String? actionUrl,
  }) async {
    if (isClosed) return;
    emit(const AdsLoading());
    try {
      final result = await _createAdUseCase(
        title: title,
        imageUrl: imageUrl,
        description: description,
        actionUrl: actionUrl,
      );
      if (isClosed) return;
      if (result is Success) {
        await loadAds();
      } else {
        emit(AdsError((result as ResultFailure).failure.message));
      }
    } catch (e) {
      if (!isClosed) emit(AdsError('Unexpected error occurred: $e'));
    }
  }

  Future<void> updateAd(
    String id, {
    String? title,
    String? imageUrl,
    String? description,
    String? actionUrl,
    bool? isActive,
  }) async {
    if (isClosed) return;
    emit(const AdsLoading());
    try {
      final result = await _updateAdUseCase(
        id,
        title: title,
        imageUrl: imageUrl,
        description: description,
        actionUrl: actionUrl,
        isActive: isActive,
      );
      if (isClosed) return;
      if (result is Success) {
        await loadAds();
      } else {
        emit(AdsError((result as ResultFailure).failure.message));
      }
    } catch (e) {
      if (!isClosed) emit(AdsError('Unexpected error occurred: $e'));
    }
  }

  Future<void> deleteAd(String id) async {
    if (isClosed) return;
    emit(const AdsLoading());
    try {
      final result = await _deleteAdUseCase(id);
      if (isClosed) return;
      if (result is Success) {
        await loadAds();
      } else {
        emit(AdsError((result as ResultFailure).failure.message));
      }
    } catch (e) {
      if (!isClosed) emit(AdsError('Unexpected error occurred: $e'));
    }
  }

  /// Uploads an image from a file path and returns the public URL.
  /// Returns `null` on failure.
  Future<String?> uploadAdImage(String filePath, {String? folder}) async {
    final result = await _repository.uploadImage(filePath, folder: folder);
    if (result is Success<Map<String, String>>) {
      return result.value['url'];
    }
    return null;
  }

  /// Uploads an image from a byte list and returns the public URL.
  /// Returns `null` on failure.
  Future<String?> uploadAdImageBytes(List<int> bytes, {String fileName = 'upload.jpg', String? folder}) async {
    final result = await _repository.uploadImageBytes(bytes, fileName: fileName, folder: folder);
    if (result is Success<Map<String, String>>) return result.value['url'];
    return null;
  }
}
