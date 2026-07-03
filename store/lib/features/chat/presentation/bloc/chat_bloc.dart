import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/domain/usecases/chat_usecases.dart';
import 'package:store/features/chat/presentation/bloc/chat_event.dart';
import 'package:store/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final StreamMessagesUseCase streamMessagesUseCase;
  final GetChatIdUseCase getChatIdUseCase;
  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required this.sendMessageUseCase,
    required this.streamMessagesUseCase,
    required this.getChatIdUseCase,
  }) : super(ChatInitial()) {
    on<GetChatIdRequested>((event, emit) {
      final chatId = getChatIdUseCase(event.currentUserId, event.otherUserId);
      emit(ChatIdLoaded(chatId));
    });

    on<StreamMessagesRequested>((event, emit) async {
      emit(ChatLoading());
      await _messagesSubscription?.cancel();
      _messagesSubscription = streamMessagesUseCase(event.chatId).listen(
        (messages) => add(MessagesUpdated(messages)),
      );
    });

    on<MessagesUpdated>((event, emit) {
      emit(MessagesLoaded(event.messages));
    });

    on<SendMessageRequested>((event, emit) async {
      final result = await sendMessageUseCase(event.chatId, event.message);
      result.fold(
        (failure) {
          if (state is MessagesLoaded) {
            final currentState = state as MessagesLoaded;
            emit(MessagesLoaded(currentState.messages, errorMessage: failure.message));
          } else {
            emit(ChatError(failure.message));
          }
        },
        (_) => null,
      );
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
