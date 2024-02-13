import 'package:bluetooth_messaging_project/core/enum/message_type.dart';

class MessageModel {
  final String senderId;
  final String content;
  final MessageType type;

  MessageModel({
    required this.senderId,
    required this.content,
    required this.type,
  });
}
