import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_messaging_project/app/views/chat/mixin/chat_view_mixin.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/chat_bubble.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/play_sound.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/record_sound.dart';
import 'package:bluetooth_messaging_project/core/common/common_text_form_field.dart';
import 'package:bluetooth_messaging_project/core/common/models/message_model.dart';
import 'package:bluetooth_messaging_project/core/enum/chat_type.dart';
import 'package:bluetooth_messaging_project/core/enum/message_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

@RoutePage()
class ChatView extends StatefulWidget {
  final List<Device> devices;
  final NearbyService service;
  final ChatType type;
  const ChatView({
    super.key,
    required this.devices,
    required this.service,
    this.type = ChatType.single,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with ChatViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.devices.map((e) => e.deviceName).join(", ")),
        leading: IconButton(
          onPressed: () async {
            await widget.service
                .disconnectPeer(deviceID: widget.devices.first.deviceId);
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
            (!isRecording && audioPath != null)
                ? PlaySound(
                    duration: getDuration(),
                    position: position,
                    maxDuration: maxDuration ?? recordDuration,
                    isPlaying: isPlaying,
                    player: player,
                    playRecording: playRecording,
                  )
                : isRecording
                    ? RecordSound(
                        duration: getDuration(),
                        noises: amplitudes,
                        controller: noiseController,
                      )
                    : Expanded(
                        child: CommonTextFormField(
                          hintText: 'Type a message',
                          controller: controller,
                          onChanged: (value) {
                            setState(() {
                              controller.text = value;
                            });
                          },
                        ),
                      ),
            audioPath == null
                ? IconButton(
                    onPressed: isRecording ? stopRecording : recordAudio,
                    icon: Icon(isRecording ? Icons.stop : Icons.mic),
                  )
                : const SizedBox.shrink(),
            IconButton(
              onPressed: () async {
                if (controller.text == "/clear") {
                  setState(() {
                    messages.clear();
                    controller.clear();
                  });
                  return;
                }

                MessageModel message = MessageModel(
                  content: audioPath ?? controller.text,
                  type: MessageType.sender,
                  isVoiceMessage: audioPath != null,
                );
                for (Device device in widget.devices) {
                  await widget.service.sendMessage(
                    device.deviceId,
                    controller.text,
                  );
                }
                setState(() {
                  messages.add(message);
                  controller.clear();
                });
              },
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            MessageModel model = messages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ChatBubble(
                deviceId: model.senderId ?? '',
                message: model.content,
                isSender: model.type == MessageType.sender ? true : false,
                isVoiceMessage: model.isVoiceMessage,
                voiceMessage: model.isVoiceMessage
                    ? PlaySound(
                        duration: getDuration(),
                        position: position,
                        maxDuration: maxDuration ?? recordDuration,
                        isPlaying: isPlaying,
                        player: player,
                        playRecording: playRecording,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
