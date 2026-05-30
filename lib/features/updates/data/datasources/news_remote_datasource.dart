import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/updates/data/models/news_item_model.dart';

class NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSource() : _dio = DioClient.instance.dio;

  Future<List<NewsItem>> getLatestNews() async {
    try {
      final response = await _dio.get(ApiEndpoints.news);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((item) => NewsItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
