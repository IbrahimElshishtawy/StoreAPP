import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';
import 'package:store/features/chat/data/datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return remoteDataSource.streamMessages(chatId);
  }

  @override
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    return remoteDataSource.sendMessage(chatId, message);
  }
}
