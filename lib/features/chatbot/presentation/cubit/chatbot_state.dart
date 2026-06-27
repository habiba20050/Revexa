import 'package:equatable/equatable.dart';
import 'package:revexa/features/chatbot/data/models/chat_message_model.dart';

abstract class ChatbotState extends Equatable {
  final List<ChatMessage> messages;
  const ChatbotState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial() : super(const []);
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading(super.messages);
}

class ChatbotSuccess extends ChatbotState {
  const ChatbotSuccess(super.messages);
}

class ChatbotError extends ChatbotState {
  final String error;
  const ChatbotError(super.messages, this.error);

  @override
  List<Object?> get props => [messages, error];
}
