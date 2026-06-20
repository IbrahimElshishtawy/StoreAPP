import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/domain/usecases/chat_usecases.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StreamMessagesUseCase streamMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required this.streamMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitial()) {
    on<StreamMessagesRequested>(_onStreamMessagesRequested);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<SendMessageRequested>(_onSendMessageRequested);
  }

  Future<void> _onStreamMessagesRequested(
    StreamMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    await _messagesSubscription?.cancel();
    _messagesSubscription = streamMessagesUseCase(event.chatId).listen(
      (messages) => add(MessagesUpdated(messages)),
      onError: (error) => emit(ChatError(error.toString())),
    );
  }

  void _onMessagesUpdated(
    MessagesUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(MessagesLoaded(event.messages));
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await sendMessageUseCase(event.chatId, event.message);
    } catch (e) {
      if (state is MessagesLoaded) {
        final currentState = state as MessagesLoaded;
        emit(MessagesLoaded(currentState.messages, errorMessage: e.toString()));
      } else {
        emit(ChatError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
