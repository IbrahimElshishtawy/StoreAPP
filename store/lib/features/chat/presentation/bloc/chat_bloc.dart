import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/domain/usecases/chat_usecases.dart';
import 'package:store/features/chat/presentation/bloc/chat_event.dart';
import 'package:store/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StreamMessagesUseCase streamMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetChatIdUseCase getChatIdUseCase;

  StreamSubscription? _messageSubscription;

  ChatBloc({
    required this.streamMessagesUseCase,
    required this.sendMessageUseCase,
    required this.getChatIdUseCase,
  }) : super(ChatInitial()) {
    on<StreamMessagesRequested>((event, emit) async {
      await _messageSubscription?.cancel();
      _messageSubscription = streamMessagesUseCase(event.chatId).listen(
        (messages) => add(_MessagesReceived(messages)),
        onError: (error) => add(_ChatErrorOccurred(error.toString())),
      );
    });

    on<_MessagesReceived>((event, emit) {
      emit(MessagesUpdated(event.messages));
    });

    on<SendMessageRequested>((event, emit) async {
      try {
        await sendMessageUseCase(event.chatId, event.message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<GetChatIdRequested>((event, emit) {
      final chatId = getChatIdUseCase(event.currentUserId, event.otherUserId);
      emit(ChatIdGenerated(chatId));
    });

    on<_ChatErrorOccurred>((event, emit) {
      emit(ChatError(event.message));
    });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}

class _MessagesReceived extends ChatEvent {
  final List<ChatMessage> messages;
  _MessagesReceived(this.messages);
}

class _ChatErrorOccurred extends ChatEvent {
  final String message;
  _ChatErrorOccurred(this.message);
}
