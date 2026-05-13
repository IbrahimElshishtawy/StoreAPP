import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';

abstract class ChatEvent {}

class GetMessagesRequested extends ChatEvent {
  final String peerId;
  GetMessagesRequested(this.peerId);
}

class SendMessageRequested extends ChatEvent {
  final String peerId;
  final String text;
  SendMessageRequested(this.peerId, this.text);
}

class MessagesUpdated extends ChatEvent {
  final List<ChatMessage> messages;
  MessagesUpdated(this.messages);
}

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<GetMessagesRequested>((event, emit) {
      emit(ChatLoading());
      repository.getMessages(event.peerId).listen((messages) {
        add(MessagesUpdated(messages));
      });
    });

    on<MessagesUpdated>((event, emit) {
      emit(ChatLoaded(event.messages));
    });

    on<SendMessageRequested>((event, emit) async {
      final result = await repository.sendMessage(event.peerId, event.text);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) => null,
      );
    });
  }
}
