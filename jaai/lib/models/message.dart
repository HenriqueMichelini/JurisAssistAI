class Message {
  final int id;
  final String message;
  final String timestamp;
  final int isSentByMe;

  Message({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.isSentByMe,
  });
}
