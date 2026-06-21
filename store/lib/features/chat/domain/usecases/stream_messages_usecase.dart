import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/repositories/chat_repository.dart';

class StreamMessagesUseCase {
  final ChatRepository repository;

  StreamMessagesUseCase(this.repository);

  Stream<List<ChatMessage>> call(String chatId) {
    return repository.streamMessages(chatId);
  }
}
