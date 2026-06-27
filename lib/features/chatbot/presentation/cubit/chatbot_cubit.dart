import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:revexa/features/chatbot/data/models/chat_message_model.dart';
import 'package:revexa/features/chatbot/presentation/cubit/chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final ChatbotRemoteDataSource _remoteDataSource;

  ChatbotCubit(this._remoteDataSource) : super(const ChatbotInitial());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final currentMessages = List<ChatMessage>.from(state.messages)..add(userMessage);
    emit(ChatbotLoading(currentMessages));

    try {
      // Send message along with history of the last 10 messages
      final history = state.messages.length > 10
          ? state.messages.sublist(state.messages.length - 10)
          : state.messages;

      final botResponse = await _remoteDataSource.sendChatMessage(
        message: text,
        history: history,
      );

      final botMessage = ChatMessage(
        text: botResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      final updatedMessages = List<ChatMessage>.from(currentMessages)..add(botMessage);
      emit(ChatbotSuccess(updatedMessages));
    } catch (e) {
      emit(ChatbotError(currentMessages, e.toString()));
    }
  }

  void clearChat() {
    emit(const ChatbotInitial());
  }
}
