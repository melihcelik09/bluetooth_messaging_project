import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/chat_bubble.dart';
import 'package:bluetooth_messaging_project/core/common/common_text_form_field.dart';
import 'package:bluetooth_messaging_project/core/common/models/message_model.dart';
import 'package:bluetooth_messaging_project/core/enum/chat_type.dart';
import 'package:bluetooth_messaging_project/core/enum/message_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

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

class _ChatViewState extends State<ChatView> {
  late StreamSubscription receivedDataSubscription;
  List<MessageModel> messages = [];
  late TextEditingController _controller;
  late AudioRecorder _recorder;
  late AudioPlayer _player;
  late Duration _position;
  bool isRecording = false;
  bool isPlaying = false;
  String? audioPath;
  Duration? maxDuration;
  Timer? _timer;
  late Duration _recordDuration;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _recorder = AudioRecorder();
    _player = AudioPlayer();
    _position = const Duration();
    _recordDuration = const Duration();
    _player.onDurationChanged.listen((event) {
      setState(() {
        maxDuration = event;
      });
    });
    _player.onPositionChanged.listen((event) {
      if (event == maxDuration) {
        setState(() {
          isPlaying = false;
        });
      } else {
        setState(() {
          _position = event;
        });
      }
    });
    receivedDataSubscription = widget.service.dataReceivedSubscription(
      callback: (data) {
        MessageModel message = MessageModel(
          senderId: data["senderDeviceId"],
          content: data["message"],
          type: MessageType.receiver,
        );
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
    _recorder.dispose();
    _player.dispose();
  }

  Future<void> recordAudio() async {
    try {
      if (await _recorder.hasPermission()) {
        var appDirectory = await getApplicationDocumentsDirectory();
        await _recorder.start(
          const RecordConfig(),
          path: "${appDirectory.path}/recording.m4a",
        );
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration = _recordDuration + const Duration(seconds: 1);
          });
        });
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      debugPrint("Recording Error: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await _recorder.stop();
      _timer?.cancel();
      debugPrint("Record Path: $path");
      setState(() {
        isRecording = false;
        audioPath = path;
      });
    } catch (e) {
      debugPrint("Stopping Record Error: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      if (isPlaying) {
        await _player.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        File file = File(audioPath!);
        if (await file.exists()) {
          DeviceFileSource local = DeviceFileSource(audioPath!);
          await _player.play(local);
          setState(() {
            isPlaying = true;
          });
        } else {
          debugPrint("File not found");
        }
      }
    } catch (e) {
      debugPrint("Playing Record Error: $e");
    }
  }

  String getDuration() {
    if (isPlaying) {
      return formatDuration(_position);
    } else {
      return formatDuration(_recordDuration);
    }
  }

  String formatDuration(Duration duration) {
    return "${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

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
                ? ChatInputCard(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(getDuration()),
                      Slider(
                        inactiveColor: Colors.grey,
                        value: _position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          await _player.seek(Duration(seconds: value.toInt()));
                        },
                        min: 0,
                        max: maxDuration?.inSeconds.toDouble() ?? 0,
                      ),
                      IconButton(
                        onPressed: playRecording,
                        icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                      ),
                    ],
                  )
                : isRecording
                    ? ChatInputCard(
                        children: [
                          Text(
                            getDuration(),
                          ),
                        ],
                      )
                    : Expanded(
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
            audioPath == null
                ? IconButton(
                    onPressed: isRecording ? stopRecording : recordAudio,
                    icon: Icon(isRecording ? Icons.stop : Icons.mic),
                  )
                : const SizedBox.shrink(),
            IconButton(
              onPressed: () async {
                if (_controller.text == "/clear") {
                  setState(() {
                    messages.clear();
                    _controller.clear();
                  });
                  return;
                }
                MessageModel message = MessageModel(
                  content: _controller.text,
                  type: MessageType.sender,
                );
                for (Device device in widget.devices) {
                  await widget.service.sendMessage(
                    device.deviceId,
                    _controller.text,
                  );
                }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            MessageModel model = messages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ChatBubble(
                deviceId: model.senderId ?? '',
                message: model.content,
                isSender: model.type == MessageType.sender ? true : false,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatInputCard extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  const ChatInputCard({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: kToolbarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}
