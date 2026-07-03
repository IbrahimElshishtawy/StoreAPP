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
  final String? otherUserId; // If null, it's a support chat
  const ChatPage({super.key, this.otherUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  String? _currentUserId;
  String? _chatId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _currentUserId = authState.user.id;
      context.read<ChatBloc>().add(GetChatIdRequested(
            currentUserId: _currentUserId!,
            otherUserId: widget.otherUserId,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserId == null ? "Live Support" : "Chat")),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatIdLoaded) {
            _chatId = state.chatId;
            context.read<ChatBloc>().add(StreamMessagesRequested(_chatId!));
          }
          if (state is MessagesLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingIndicator();
          } else if (state is ChatError) {
            return ErrorState(message: state.message);
          } else if (state is MessagesLoaded || state is ChatIdLoaded) {
            final messages = state is MessagesLoaded ? state.messages : <ChatMessage>[];
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const EmptyState(message: "No messages yet", icon: Icons.chat_bubble_outline)
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
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
                        ),
                ),
                _buildInput(context),
              ],
            );
          }
          return const LoadingIndicator();
        },
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Enter message..."),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
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
            },
          ),
        ],
      ),
    );
  }
}
