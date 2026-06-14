import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  StreamSubscription? _subscription;

  ChatBloc({required this.firestore, required this.auth}) : super(ChatInitial()) {
    on<SendMessageRequested>((event, emit) async {
      final currentUser = auth.currentUser;
      if (currentUser == null) return;

      final chatId = _getChatId(currentUser.uid, event.otherUserId);
      final message = ChatMessage(
        id: '',
        senderId: currentUser.uid,
        text: event.text,
        timestamp: DateTime.now(),
      );

      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toFirestore());
    });

    on<StreamMessagesRequested>((event, emit) async {
      emit(ChatLoading());
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        emit(const ChatError("User not logged in"));
        return;
      }

      final chatId = _getChatId(currentUser.uid, event.otherUserId);

      await _subscription?.cancel();
      _subscription = firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
            final messages = snapshot.docs
                .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
                .toList();
            add(_UpdateMessages(messages));
          });
    });

    on<_UpdateMessages>((event, emit) {
      emit(ChatMessagesLoaded(event.messages));
    });
  }

  String _getChatId(String currentUserId, String? otherUserId) {
    if (otherUserId == null) return "support_$currentUserId";
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    return ids.join("_");
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _UpdateMessages extends ChatEvent {
  final List<ChatMessage> messages;
  const _UpdateMessages(this.messages);
  @override
  List<Object> get props => [messages];
}
