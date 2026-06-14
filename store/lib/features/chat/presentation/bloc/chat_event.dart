import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class SendMessageRequested extends ChatEvent {
  final String text;
  final String? otherUserId;
  const SendMessageRequested(this.text, {this.otherUserId});
  @override
  List<Object> get props => [text, otherUserId ?? ''];
}

class StreamMessagesRequested extends ChatEvent {
  final String? otherUserId;
  const StreamMessagesRequested({this.otherUserId});
  @override
  List<Object> get props => [otherUserId ?? ''];
}
