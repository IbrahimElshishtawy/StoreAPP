import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return remoteDataSource.getMessages(chatId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(String chatId, ChatMessage message) async {
    try {
      await remoteDataSource.sendMessage(chatId, message);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
