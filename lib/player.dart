import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  // kontruktor do przekazania zmiennej playerX z homepage.dart do player.dart
  final playerX;

  MyPlayer({this.playerX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.red,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}
