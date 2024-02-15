import 'package:audioplayers/audioplayers.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/chat_input_card.dart';
import 'package:flutter/material.dart';

class PlaySound extends StatelessWidget {
  final String duration;
  final Duration position;
  final Duration maxDuration;
  final bool isPlaying;
  final AudioPlayer player;
  final void Function() playRecording;
  const PlaySound({
    super.key,
    required this.duration,
    required this.position,
    required this.maxDuration,
    required this.isPlaying,
    required this.player,
    required this.playRecording,
  });

  @override
  Widget build(BuildContext context) {
    return ChatInputCard(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(duration),
        Slider(
          inactiveColor: Colors.grey,
          value: position.inSeconds.toDouble(),
          onChanged: (value) async {
            await player.seek(Duration(seconds: value.toInt()));
          },
          min: 0,
          max: maxDuration.inSeconds.toDouble(),
        ),
        IconButton(
          onPressed: playRecording,
          icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
        ),
      ],
    );
  }
}
