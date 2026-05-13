import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';
import 'package:store/features/chat/data/datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ChatMessage>> getMessages(String peerId) {
    return remoteDataSource.getMessages(peerId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(String peerId, String text) async {
    try {
      await remoteDataSource.sendMessage(peerId, text);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
