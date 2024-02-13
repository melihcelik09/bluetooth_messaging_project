import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String deviceId;
  final String message;
  const ChatBubble({
    super.key,
    this.isSender = false,
    required this.message,
    required this.deviceId,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSender
                ? const SizedBox.shrink()
                : Text(
                    deviceId,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
