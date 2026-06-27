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
      _currentUserId = authState.user.uid;
      context.read<ChatBloc>().add(
            GetChatIdRequested(
              currentUserId: _currentUserId!,
              otherUserId: widget.otherUserId,
            ),
          );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserId == null ? "Live Support" : "Chat")),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatIdLoaded) {
            _chatId = state.chatId;
            context.read<ChatBloc>().add(StreamMessagesRequested(_chatId!));
          } else if (state is MessagesLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading || state is ChatInitial) {
                    return const LoadingIndicator();
                  } else if (state is ChatError) {
                    return ErrorState(
                      message: state.message,
                      onRetry: () {
                        if (_chatId != null) {
                          context.read<ChatBloc>().add(StreamMessagesRequested(_chatId!));
                        }
                      },
                    );
                  } else if (state is MessagesLoaded) {
                    final messages = state.messages;
                    if (messages.isEmpty) {
                      return const EmptyState(message: "No messages yet. Say hi!", icon: Icons.chat_bubble_outline);
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId == _currentUserId;
                        return _buildMessageBubble(message, isMe);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            if (_chatId != null) _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty && _chatId != null && _currentUserId != null) {
      context.read<ChatBloc>().add(
            SendMessageRequested(
              chatId: _chatId!,
              text: _controller.text.trim(),
              senderId: _currentUserId!,
            ),
          );
      _controller.clear();
    }
  }
}
