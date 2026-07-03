import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  Future<Either<Failure, void>> call(String chatId, ChatMessage message) {
    return repository.sendMessage(chatId, message);
  }
}

class StreamMessagesUseCase {
  final ChatRepository repository;
  StreamMessagesUseCase(this.repository);

  Stream<List<ChatMessage>> call(String chatId) {
    return repository.streamMessages(chatId);
  }
}

class GetChatIdUseCase {
  final ChatRepository repository;
  GetChatIdUseCase(this.repository);

  String call(String currentUserId, String? otherUserId) {
    return repository.getChatId(currentUserId, otherUserId);
  }
}
