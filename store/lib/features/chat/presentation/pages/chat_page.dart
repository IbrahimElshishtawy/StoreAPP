import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_state.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/domain/usecases/chat_usecases.dart';
import 'package:store/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:store/features/chat/presentation/bloc/chat_event.dart';
import 'package:store/features/chat/presentation/bloc/chat_state.dart';
import 'package:store/core/injection/injection_container.dart' as di;
import 'package:store/presentation/widgets/common_ui.dart';

class ChatPage extends StatefulWidget {
  final String? otherUserId; // If null, it's a support chat
  const ChatPage({super.key, this.otherUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late final ChatBloc _chatBloc;
  late final String _currentUserId;
  late final String _chatId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _currentUserId = authState.user.id;
      _chatBloc = di.sl<ChatBloc>();
      _chatId = di.sl<GetChatIdUseCase>().call(_currentUserId, widget.otherUserId);
      _chatBloc.add(StreamMessagesRequested(_chatId));
    } else {
      // Handle unauthenticated state if necessary, but usually handled by parent
      _currentUserId = '';
      _chatId = '';
    }
  }

  @override
  void dispose() {
    _chatBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.otherUserId == null ? "Live Support" : "Chat")),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is MessagesLoaded && state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
                    );
                  } else if (state is ChatError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const LoadingIndicator();
                  } else if (state is ChatError && state is! MessagesLoaded) {
                    return ErrorState(
                      message: state.message,
                      onRetry: () => _chatBloc.add(StreamMessagesRequested(_chatId)),
                    );
                  } else if (state is MessagesLoaded) {
                    final messages = state.messages;
                    if (messages.isEmpty) {
                      return const EmptyState(message: "No messages yet. Say hi!");
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId == _currentUserId;
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.teal : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                topRight: const Radius.circular(15),
                                bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
                                bottomRight: isMe ? Radius.zero : const Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty) {
                          final message = ChatMessage(
                            id: '',
                            senderId: _currentUserId,
                            text: _controller.text.trim(),
                            timestamp: DateTime.now(),
                          );
                          _chatBloc.add(SendMessageRequested(_chatId, message));
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
