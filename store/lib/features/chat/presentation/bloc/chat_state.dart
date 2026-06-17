import 'package:equatable/equatable.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  final String? errorMessage;

  const MessagesLoaded(this.messages, {this.errorMessage});

  @override
  List<Object?> get props => [messages, errorMessage];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
