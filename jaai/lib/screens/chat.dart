import 'package:flutter/material.dart';
import 'package:jaai/components/message_bubble.dart';
import 'package:jaai/components/styled_container.dart';
import 'package:jaai/models/message.dart';
import 'package:jaai/services/dart_logic.dart';
import 'package:jaai/services/database_service.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
    if (messageText.isNotEmpty) {
      _databaseService.insertMessage(messageText, true);
      _controller.clear();

      // Instantiate and use the PythonToDart class
      var pyOutput = await PythonToDart.instance.runPythonScript(
          messageText, ["oi", "blz"] // Replace with your actual keywords
          );

      // Insert the Python output into the database
      _databaseService.insertMessage(pyOutput, false);

      setState(() {});

      // Ensure the scroll happens after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      _focusNode.requestFocus();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
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
        ),
      ),
    );
  }

  Widget _messagesList() {
    return FutureBuilder<List<Message>>(
      future: _databaseService.getMessages(),
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
