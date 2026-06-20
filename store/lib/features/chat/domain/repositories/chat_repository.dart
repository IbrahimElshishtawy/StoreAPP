import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> streamMessages(String chatId);
  Future<void> sendMessage(String chatId, ChatMessage message);
  String getChatId(String userId, String? otherUserId);
}
