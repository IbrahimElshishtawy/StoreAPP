import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> sendMessage(String chatId, ChatMessage message) async {
    try {
      await remoteDataSource.sendMessage(chatId, message);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return remoteDataSource.streamMessages(chatId);
  }

  @override
  String getChatId(String currentUserId, String? otherUserId) {
    if (otherUserId == null) return "support_$currentUserId";
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    return ids.join("_");
  }
}
