import 'dart:async';

import 'package:bubble_trouble_game/button.dart';
import 'package:bubble_trouble_game/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // player variables
  static double playerX = 0;

  //missile variables
  double missileX = playerX;
  double missileY = 1;
  double missileHeight = 10;

  // zapis playerX -= 0.1; == playerX = playerX - 0.1;
  // to not go of screen
  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        //do nothing
      } else {
        playerX -= 0.1;
      }
      missileX = playerX;
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        //do nothing
      } else {
        playerX += 0.1;
      }
      missileX = playerX;
    });
  }

  // 3/4 ponieważ różowa część ekranu jest ustawiona na flex:3
  void fireMissile() {
    Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
        //stop missile
        resetMissile();
        timer.cancel();
      } else {
        setState(() {
          missileHeight += 10;
        });
      }
    });
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
  }

  @override
  Widget build(BuildContext context) {
    // for using keyboard
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment(missileX, missileY),
                      child: Container(
                        width: 3,
                        height: missileHeight,
                        color: Colors.grey,
                      ),
                    ),
                    MyPlayer(
                      //przekazanie parametru playerX z homepage.dart do player.dart
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
