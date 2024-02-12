import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  const ChatBubble({
    super.key,
    this.isSender = false,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.grey,
        ),
        child: Text(message),
      ),
    );
  }
}
