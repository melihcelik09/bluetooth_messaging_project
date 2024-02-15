import 'package:bluetooth_messaging_project/core/enum/message_type.dart';

class MessageModel {
  String? senderId;
  final String content;
  final MessageType type;
  final bool isVoiceMessage;

  MessageModel({
    this.senderId,
    required this.content,
    required this.type,
    this.isVoiceMessage = false,
  });
}
