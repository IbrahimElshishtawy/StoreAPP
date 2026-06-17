import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:store/features/chat/domain/usecases/stream_messages_usecase.dart';
import 'package:store/features/chat/domain/usecases/get_chat_id_usecase.dart';
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
        (_) => {}, // Handled by stream
      );
    });

    on<StreamMessagesRequested>((event, emit) {
      emit(ChatLoading());
      _messagesSubscription?.cancel();
      _messagesSubscription = streamMessagesUseCase(event.chatId).listen(
        (messages) => add(MessagesUpdated(messages)),
        onError: (error) => add(MessagesUpdated(const [])),
      );
    });

    on<MessagesUpdated>((event, emit) {
      emit(MessagesLoaded(event.messages));
    });
  }

  String getChatId(String userId, String? otherUserId) {
    return getChatIdUseCase(userId, otherUserId);
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
