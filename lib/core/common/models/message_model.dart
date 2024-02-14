import 'package:bluetooth_messaging_project/core/enum/message_type.dart';

class MessageModel {
  String? senderId;
  final String content;
  final MessageType type;

  MessageModel({
    this.senderId,
    required this.content,
    required this.type,
  });
}
