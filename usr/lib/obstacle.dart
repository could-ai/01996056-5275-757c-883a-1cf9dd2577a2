import 'package:flutter/material.dart';

class Obstacle extends StatelessWidget {
  final double width;
  final double height;

  const Obstacle({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
