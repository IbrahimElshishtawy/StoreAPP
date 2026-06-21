import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessagesStarted extends ChatEvent {
  final String chatId;
  const LoadMessagesStarted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessageRequested extends ChatEvent {
  final String chatId;
  final String senderId;
  final String text;

  const SendMessageRequested({
    required this.chatId,
    required this.senderId,
    required this.text,
  });

  @override
  List<Object?> get props => [chatId, senderId, text];
}

class MessagesUpdated extends ChatEvent {
  final List<dynamic> messages;
  const MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}
