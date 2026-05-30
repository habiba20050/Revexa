import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/updates/data/models/news_item_model.dart';

class NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSource() : _dio = DioClient.instance.dio;

  /// GET /api/news?page=1&limit=10 — matches backend [getStoredNews].
  Future<NewsPage> getStoredNews({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.news,
        queryParameters: {'page': page, 'limit': limit},
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return const NewsPage(items: [], total: 0, currentPage: 1, totalPages: 0);
      }
      if (body['status']?.toString() == 'success' || body['data'] is List) {
        return NewsPage.fromJson(body);
      }
      final message = body['message']?.toString() ?? 'Failed to load news';
      throw Exception(message);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  /// POST /api/news/sync — fetches from NewsAPI and saves to MongoDB (admin/cron).
  Future<void> syncCarsNews() async {
    try {
      await _dio.post(ApiEndpoints.newsSync);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
