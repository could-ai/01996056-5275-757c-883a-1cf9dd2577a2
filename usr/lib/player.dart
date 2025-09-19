import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final double width;
  final double height;

  const Player({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
