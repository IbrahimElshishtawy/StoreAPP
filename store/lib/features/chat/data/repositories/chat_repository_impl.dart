import 'package:store/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return remoteDataSource.streamMessages(chatId);
  }

  @override
  Future<void> sendMessage(String chatId, ChatMessage message) {
    return remoteDataSource.sendMessage(chatId, message);
  }

  @override
  String getChatId(String userId, String? otherUserId) {
    if (otherUserId == null) return "support_$userId";
    List<String> ids = [userId, otherUserId];
    ids.sort();
    return ids.join("_");
  }
}
