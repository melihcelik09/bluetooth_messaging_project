import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/play_sound.dart';
import 'package:bluetooth_messaging_project/core/extension/duration_extension.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ChatBubble extends StatefulWidget {
  final bool isSender;
  final bool isVoiceMessage;
  final String deviceId;
  final String message;
  const ChatBubble({
    super.key,
    this.isSender = false,
    required this.message,
    required this.deviceId,
    required this.isVoiceMessage,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  late AudioPlayer player;
  late Duration position;
  bool isRecording = false;
  bool isPlaying = false;
  String? audioPath;
  Duration? maxDuration;

  String getDuration() {
    if (isPlaying) {
      return position.format;
    } else {
      return maxDuration?.format ?? position.format;
    }
  }

  @override
  void initState() {
    player = AudioPlayer();
    position = const Duration();

    super.initState();
    player.onDurationChanged.listen((event) {
      setState(() {
        maxDuration = event;
      });
    });
    player.onPositionChanged.listen((event) {
      if (event == maxDuration) {
        setState(() {
          isPlaying = false;
        });
      } else {
        setState(() {
          position = event;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Voice ${widget.isVoiceMessage}");
    return Align(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
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
            widget.isSender
                ? const SizedBox.shrink()
                : Text(
                    widget.deviceId,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
            widget.isVoiceMessage
                ? PlaySound(
                    duration: getDuration(),
                    position: position,
                    maxDuration: maxDuration ?? position,
                    isPlaying: isPlaying,
                    player: player,
                    playRecording: () async {
                      List<int> audio = utf8.encode(widget.message);
                      Uint8List audioByte = Uint8List.fromList(audio);
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final path = "${directory.path}/recording.m4a";
                      await File(path).writeAsBytes(audioByte);
                      final Source source = DeviceFileSource(path);
                      await player.play(source);
                    },
                  )
                : Text(
                    widget.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ],
        ),
      ),
    );
  }
}
