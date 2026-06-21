import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_state.dart';
import 'package:store/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:store/features/chat/presentation/bloc/chat_event.dart';
import 'package:store/features/chat/presentation/bloc/chat_state.dart';
import 'package:store/features/chat/domain/usecases/get_chat_id_usecase.dart';
import 'package:store/core/injection/injection_container.dart';
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
      _currentUserId = authState.user.uid;
      _chatId = sl<GetChatIdUseCase>().call(_currentUserId!, widget.otherUserId);
      context.read<ChatBloc>().add(LoadMessagesStarted(_chatId!));
    }
  }

  void _onRetry() {
    if (_chatId != null) {
      context.read<ChatBloc>().add(LoadMessagesStarted(_chatId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null || _chatId == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to use chat")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserId == null ? "Live Support" : "Chat")),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is MessagesLoaded && state.errorMessage != null) {
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
                  if (state is ChatLoading) {
                    return const LoadingIndicator();
                  } else if (state is ChatError) {
                    return ErrorState(
                      message: state.message,
                      onRetry: _onRetry,
                    );
                  } else if (state is MessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return const EmptyState(message: "No messages yet. Say hi!");
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
                      decoration: const InputDecoration(hintText: "Enter message..."),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        context.read<ChatBloc>().add(SendMessageRequested(
                              chatId: _chatId!,
                              senderId: _currentUserId!,
                              text: _controller.text.trim(),
                            ));
                        _controller.clear();
                      }
                    },
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
