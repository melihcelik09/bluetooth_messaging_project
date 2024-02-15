import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      ),
    );
  }
}
