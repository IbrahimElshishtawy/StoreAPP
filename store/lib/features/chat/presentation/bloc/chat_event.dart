import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatEvent {}

class SendMessageRequested extends ChatEvent {
  final ChatMessage message;
  SendMessageRequested(this.message);
}

class ReceiveMessagesRequested extends ChatEvent {
  final String chatId;
  ReceiveMessagesRequested(this.chatId);
}
