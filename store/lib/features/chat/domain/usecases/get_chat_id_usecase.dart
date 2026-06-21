class GetChatIdUseCase {
  String call(String currentUserId, String? otherUserId) {
    if (otherUserId == null) return "support_$currentUserId";
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    return ids.join("_");
  }
}
