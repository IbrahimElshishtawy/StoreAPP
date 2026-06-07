import 'package:equatable/equatable.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class StreamMessagesRequested extends ChatEvent {
  final String chatId;
  const StreamMessagesRequested(this.chatId);
  @override
  List<Object?> get props => [chatId];
}

class SendMessageRequested extends ChatEvent {
  final String chatId;
  final ChatMessage message;
  const SendMessageRequested(this.chatId, this.message);
  @override
  List<Object?> get props => [chatId, message];
}

class MessagesUpdated extends ChatEvent {
  final List<ChatMessage> messages;
  const MessagesUpdated(this.messages);
  @override
  List<Object?> get props => [messages];
}
