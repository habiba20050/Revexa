import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/updates/data/datasources/news_remote_datasource.dart';
import 'package:revexa/features/updates/data/models/news_item_model.dart';

class NewsRepository {
  final NewsRemoteDataSource _remote;

  NewsRepository(this._remote);

  Future<Result<NewsPage>> getStoredNews({int page = 1, int limit = 20}) async {
    try {
      final result = await _remote.getStoredNews(page: page, limit: limit);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  Future<Result<void>> syncCarsNews() async {
    try {
      await _remote.syncCarsNews();
      return const Success(null);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }
}
