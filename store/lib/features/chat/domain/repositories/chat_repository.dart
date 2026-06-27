import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> streamMessages(String chatId);
  Future<Either<Failure, void>> sendMessage(String chatId, ChatMessage message);
  String getChatId(String currentUserId, String? otherUserId);
}
