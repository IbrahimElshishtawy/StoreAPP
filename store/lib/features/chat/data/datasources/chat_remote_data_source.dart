import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage(String chatId, ChatMessage message);
  Stream<List<ChatMessage>> streamMessages(String chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toFirestore());
  }

  @override
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}
