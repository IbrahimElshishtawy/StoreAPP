import 'package:equatable/equatable.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class MessagesUpdated extends ChatState {
  final List<ChatMessage> messages;
  MessagesUpdated(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatIdGenerated extends ChatState {
  final String chatId;
  ChatIdGenerated(this.chatId);
  @override
  List<Object?> get props => [chatId];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
