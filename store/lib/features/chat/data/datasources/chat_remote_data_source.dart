import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessage>> getMessages(String peerId);
  Future<void> sendMessage(String peerId, String text);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRemoteDataSourceImpl(this.firestore, this.auth);

  @override
  Stream<List<ChatMessage>> getMessages(String peerId) {
    final currentUserId = auth.currentUser!.uid;
    final chatId = _getChatId(currentUserId, peerId);

    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          id: doc.id,
          senderId: data['senderId'],
          text: data['text'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String peerId, String text) async {
    final currentUserId = auth.currentUser!.uid;
    final chatId = _getChatId(currentUserId, peerId);

    await firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': currentUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  String _getChatId(String id1, String id2) {
    if (id1.hashCode <= id2.hashCode) {
      return '${id1}_$id2';
    } else {
      return '${id2}_$id1';
    }
  }
}
