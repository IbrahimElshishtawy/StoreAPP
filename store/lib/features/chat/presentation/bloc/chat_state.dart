import 'package:equatable/equatable.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  const ChatMessagesLoaded(this.messages);
  @override
  List<Object> get props => [messages];
}
class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object> get props => [message];
}
