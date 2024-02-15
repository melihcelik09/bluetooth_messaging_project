import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final bool isVoiceMessage;
  final String deviceId;
  final String message;
  final Widget? voiceMessage;
  const ChatBubble({
    super.key,
    this.isSender = false,
    required this.message,
    required this.deviceId,
    required this.isVoiceMessage,
    this.voiceMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[300],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            isVoiceMessage
                ? voiceMessage ?? const SizedBox.shrink()
                : Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ],
        ),
      ),
    );
  }
}
