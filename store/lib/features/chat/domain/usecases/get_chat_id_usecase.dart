import 'package:store/features/chat/domain/repositories/chat_repository.dart';

class GetChatIdUseCase {
  final ChatRepository repository;

  GetChatIdUseCase(this.repository);

  String call(String userId, String? otherUserId) {
    return repository.generateChatId(userId, otherUserId);
  }
}
