import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessage>> streamMessages(String chatId);
  Future<void> sendMessage(String chatId, ChatMessage message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessage.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toFirestore());
  }
}
