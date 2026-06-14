import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<ChatBloc>().add(StreamMessagesRequested(otherUserId: widget.otherUserId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserId == null ? "Live Support" : "Chat")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const LoadingIndicator();
                } else if (state is ChatError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: () => context.read<ChatBloc>().add(
                          StreamMessagesRequested(otherUserId: widget.otherUserId),
                        ),
                  );
                } else if (state is ChatMessagesLoaded) {
                  final messages = state.messages;
                  if (messages.isEmpty) {
                    return const EmptyState(
                      message: "No messages yet. Start the conversation!",
                      icon: Icons.chat_bubble_outline,
                    );
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
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.teal : Colors.grey[200],
                            borderRadius: BorderRadius.circular(15).copyWith(
                              bottomRight: isMe ? const Radius.circular(0) : null,
                              bottomLeft: !isMe ? const Radius.circular(0) : null,
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                        context.read<ChatBloc>().add(
                              SendMessageRequested(
                                _controller.text.trim(),
                                otherUserId: widget.otherUserId,
                              ),
                            );
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
    );
  }
}
