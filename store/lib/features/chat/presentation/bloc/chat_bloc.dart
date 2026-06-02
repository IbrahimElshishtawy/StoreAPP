import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/chat/presentation/bloc/chat_event.dart';
import 'package:store/features/chat/presentation/bloc/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore firestore;

  ChatBloc({required this.firestore}) : super(ChatInitial()) {
    on<ReceiveMessagesRequested>((event, emit) async {
      emit(ChatLoading());
      try {
        final snapshots = firestore
            .collection('chats')
            .doc(event.chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots();

        await emit.forEach(
          snapshots,
          onData: (snapshot) {
            final messages = snapshot.docs.map((doc) {
              final data = doc.data();
              return ChatMessage(
                id: doc.id,
                senderId: data['senderId'],
                text: data['text'],
                timestamp: (data['timestamp'] as Timestamp).toDate(),
              );
            }).toList();
            return ChatMessagesLoaded(messages);
          },
          onError: (error, stackTrace) => ChatError(error.toString()),
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessageRequested>((event, emit) async {
      try {
        await firestore
            .collection('chats')
            .doc('default_chat') // Simplified for now
            .collection('messages')
            .add({
          'senderId': event.message.senderId,
          'text': event.message.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
