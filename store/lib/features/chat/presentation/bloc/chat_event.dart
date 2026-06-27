import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatEvent {}

class GetChatIdRequested extends ChatEvent {
  final String currentUserId;
  final String? otherUserId;
  GetChatIdRequested({required this.currentUserId, this.otherUserId});
}

class StreamMessagesRequested extends ChatEvent {
  final String chatId;
  StreamMessagesRequested(this.chatId);
}

class MessagesUpdated extends ChatEvent {
  final List<ChatMessage> messages;
  MessagesUpdated(this.messages);
}

class SendMessageRequested extends ChatEvent {
  final String chatId;
  final String text;
  final String senderId;
  SendMessageRequested({required this.chatId, required this.text, required this.senderId});
}

class ChatErrorOccurred extends ChatEvent {
  final String message;
  ChatErrorOccurred(this.message);
}
