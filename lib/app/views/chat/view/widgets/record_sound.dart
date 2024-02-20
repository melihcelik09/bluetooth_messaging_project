import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/chat_input_card.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/widgets/noises.dart';
import 'package:flutter/material.dart';

class RecordSound extends StatelessWidget {
  final String duration;
  final List<double> noises;
  final ScrollController controller;
  const RecordSound(
      {super.key,
      required this.duration,
      required this.noises,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ChatInputCard(
        children: [
          Text(duration),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Noises(
                noises: noises,
                color: Colors.green,
                controller: controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
