import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_state.dart';
import 'package:store/features/chat/domain/entities/chat_message.dart';
import 'package:store/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:store/features/chat/presentation/bloc/chat_event.dart';
import 'package:store/features/chat/presentation/bloc/chat_state.dart';
import 'package:store/presentation/widgets/common_ui.dart';

class ChatPage extends StatefulWidget {
  final String? otherUserId;
  const ChatPage({super.key, this.otherUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  String? _chatId;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _currentUserId = authState.user.id;
      context.read<ChatBloc>().add(GetChatIdRequested(_currentUserId!, widget.otherUserId));
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty && _chatId != null && _currentUserId != null) {
      final message = ChatMessage(
        id: '',
        senderId: _currentUserId!,
        text: _controller.text.trim(),
        timestamp: DateTime.now(),
      );
      context.read<ChatBloc>().add(SendMessageRequested(_chatId!, message));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserId == null ? "Live Support" : "Chat")),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatIdGenerated) {
            _chatId = state.chatId;
            context.read<ChatBloc>().add(StreamMessagesRequested(_chatId!));
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: _buildMessageList(state),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Enter message...",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageList(ChatState state) {
    if (state is ChatLoading) {
      return const LoadingIndicator();
    } else if (state is MessagesUpdated) {
      if (state.messages.isEmpty) {
        return const EmptyState(message: "No messages yet", icon: Icons.chat_bubble_outline);
      }
      return ListView.builder(
        reverse: true,
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final message = state.messages[index];
          final isMe = message.senderId == _currentUserId;
          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                message.text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ),
          );
        },
      );
    }
    return const Center(child: Text("Initializing chat..."));
  }
}
