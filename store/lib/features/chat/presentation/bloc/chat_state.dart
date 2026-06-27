import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatIdLoaded extends ChatState {
  final String chatId;
  ChatIdLoaded(this.chatId);
}

class MessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  final String? errorMessage;
  MessagesLoaded(this.messages, {this.errorMessage});
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
