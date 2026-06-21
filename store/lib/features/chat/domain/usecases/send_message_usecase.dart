import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(String chatId, ChatMessage message) async {
    return await repository.sendMessage(chatId, message);
  }
}
