import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getMessages(String peerId);
  Future<Either<Failure, void>> sendMessage(String peerId, String text);
}
