import 'package:flutter/material.dart';
import 'package:jaai/components/message_bubble.dart';
import 'package:jaai/components/styled_container.dart';
import 'package:jaai/models/message.dart';
import 'package:jaai/services/dart_logic.dart';
import 'package:jaai/services/database_service.dart';

class ChatT extends StatefulWidget {
  const ChatT({super.key});

  @override
  State<ChatT> createState() => _ChatTState();
}

class _ChatTState extends State<ChatT> {
  final DatabaseService _databaseService = DatabaseService.instance;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final messageText = _controller.text.trim();
    _focusNode.requestFocus(); // Ensure focus stays before clearing the input
    if (messageText.isNotEmpty) {
      _databaseService.insertMessage(messageText, true);
      _controller.clear();

      // Instantiate and use the PythonToDart class
      try {
        var pyOutput = await PythonToDart.instance.runPythonScript(
            messageText, ["oi", "blz"] // Replace with your actual keywords
            );
        // Insert the Python output into the database
        _databaseService.insertMessage(pyOutput, false);
      } catch (e) {
        print('Error running Python script: $e');
      }

      // Ensure the scroll happens after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 235),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StyledContainer(
                child: _messagesList(),
              ),
            ),
            StyledContainer(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: "Escreva sua mensagem...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color:
                          _controller.text.isEmpty ? Colors.grey : Colors.blue,
                    ),
                    onPressed: _controller.text.isEmpty ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messagesList() {
    return StreamBuilder<List<Message>>(
      stream: _databaseService.getMessagesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar mensagens'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Sem mensagens'));
        } else {
          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Message message = snapshot.data![index];
              bool isSentByMe = message.isSentByMe == 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: MessageBubble(
                  message: message.message,
                  date: message.timestamp,
                  isSentByMe: isSentByMe,
                ),
              );
            },
          );
        }
      },
    );
  }
}
