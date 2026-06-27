import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/features/chatbot/data/models/chat_message_model.dart';

abstract interface class ChatbotRemoteDataSource {
  Future<String> sendChatMessage({
    required String message,
    required List<ChatMessage> history,
  });
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final Dio _dio;

  ChatbotRemoteDataSourceImpl()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://localhost:8000/api',
            connectTimeout: const Duration(seconds: 25),
            receiveTimeout: const Duration(seconds: 25),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  @override
  Future<String> sendChatMessage({
    required String message,
    required List<ChatMessage> history,
  }) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {
          'message': message,
          'history': history.map((e) => e.toJson()).toList(),
        },
      );
      final body = response.data;
      if (body is Map && body['status'] == 'success') {
        return body['response'] as String;
      }
      return body['response']?.toString() ?? 'Error: invalid response from bot';
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
