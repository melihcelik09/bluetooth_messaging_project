import 'package:flutter/material.dart';

class Noises extends StatelessWidget {
  final ScrollController? controller;
  final List<double> noises;
  final Color color;

  const Noises({
    super.key,
    required this.noises,
    required this.color,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: noises.map((e) => _Noise(height: e, color: color)).toList(),
      ),
    );
  }
}

class _Noise extends StatelessWidget {
  final double height;
  final Color color;
  const _Noise({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      width: 2,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
