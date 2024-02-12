import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/chat_bubble.dart';
import 'package:bluetooth_messaging_project/core/common/common_text_form_field.dart';
import 'package:bluetooth_messaging_project/core/common/models/message_model.dart';
import 'package:bluetooth_messaging_project/core/enum/chat_type.dart';
import 'package:bluetooth_messaging_project/core/enum/message_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

@RoutePage()
class ChatView extends StatefulWidget {
  final List<Device> device;
  final NearbyService service;
  final ChatType type;
  const ChatView({
    super.key,
    required this.device,
    required this.service,
    this.type = ChatType.single,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late StreamSubscription receivedDataSubscription;
  List<MessageModel> messages = [];
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
    receivedDataSubscription = widget.service.dataReceivedSubscription(
      callback: (data) {
        MessageModel message =
            MessageModel(content: data["message"], type: MessageType.receiver);
        setState(() {
          messages.add(message);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    receivedDataSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.first.deviceId),
        leading: IconButton(
          onPressed: () async {
            await widget.service
                .disconnectPeer(deviceID: widget.device.first.deviceId);
            if (!context.mounted) return;
            context.router.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonTextFormField(
                hintText: 'Type a message',
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _controller.text = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                // if (widget.device.state == SessionState.notConnected) {
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text("disconnected"),
                //     backgroundColor: Colors.red,
                //   ));
                //   return;
                // }
                await widget.service.sendMessage(
                  widget.device.first.deviceId,
                  _controller.text,
                );
                MessageModel message = MessageModel(
                  content: _controller.text,
                  type: MessageType.sender,
                );

                setState(() {
                  messages.add(message);
                  _controller.clear();
                });
              },
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          MessageModel model = messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ChatBubble(
              message: model.content,
              isSender: model.type == MessageType.sender ? true : false,
            ),
          );
        },
      ),
    );
  }
}
