import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:store/features/chat/domain/usecases/stream_messages_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final StreamMessagesUseCase streamMessagesUseCase;
  StreamSubscription? _messageSubscription;

  ChatBloc({
    required this.sendMessageUseCase,
    required this.streamMessagesUseCase,
  }) : super(ChatInitial()) {
    on<LoadMessagesStarted>(_onLoadMessagesStarted);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<SendMessageRequested>(_onSendMessageRequested);
  }

  Future<void> _onLoadMessagesStarted(LoadMessagesStarted event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    await _messageSubscription?.cancel();
    _messageSubscription = streamMessagesUseCase(event.chatId).listen(
      (messages) => add(MessagesUpdated(messages)),
      onError: (error) => emit(ChatError(error.toString())),
    );
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    emit(MessagesLoaded(event.messages as List<ChatMessage>));
  }

  Future<void> _onSendMessageRequested(SendMessageRequested event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is MessagesLoaded) {
      try {
        final newMessage = ChatMessage(
          id: '',
          senderId: event.senderId,
          text: event.text,
          timestamp: DateTime.now(),
        );
        await sendMessageUseCase(event.chatId, newMessage);
      } catch (e) {
        emit(MessagesLoaded(currentState.messages, errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
