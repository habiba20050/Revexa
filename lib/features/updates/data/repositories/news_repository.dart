import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/updates/data/datasources/news_remote_datasource.dart';
import 'package:revexa/features/updates/data/models/news_item_model.dart';

class NewsRepository {
  final NewsRemoteDataSource _remote;

  NewsRepository(this._remote);

  Future<Result<List<NewsItem>>> getLatestNews() async {
    try {
      final result = await _remote.getLatestNews();
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }
}
