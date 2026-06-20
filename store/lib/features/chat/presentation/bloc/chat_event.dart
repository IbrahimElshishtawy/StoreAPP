import 'package:equatable/equatable.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StreamMessagesRequested extends ChatEvent {
  final String chatId;
  StreamMessagesRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessageRequested extends ChatEvent {
  final String chatId;
  final ChatMessage message;

  SendMessageRequested(this.chatId, this.message);

  @override
  List<Object?> get props => [chatId, message];
}

class MessagesUpdated extends ChatEvent {
  final List<ChatMessage> messages;
  MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}
