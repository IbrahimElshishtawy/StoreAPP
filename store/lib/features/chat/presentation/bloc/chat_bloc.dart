import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:store/features/chat/domain/usecases/stream_messages_usecase.dart';
import 'package:store/features/chat/presentation/bloc/chat_event.dart';
import 'package:store/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final StreamMessagesUseCase streamMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required this.streamMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitial()) {
    on<StreamMessagesRequested>((event, emit) {
      emit(ChatLoading());
      _messagesSubscription?.cancel();
      _messagesSubscription = streamMessagesUseCase(event.chatId).listen(
        (messages) => add(MessagesUpdated(messages)),
      );
    });

    on<MessagesUpdated>((event, emit) {
      emit(ChatLoaded(event.messages));
    });

    on<SendMessageRequested>((event, emit) async {
      final result = await sendMessageUseCase(event.chatId, event.message);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) => {}, // Handled by stream
      );
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
