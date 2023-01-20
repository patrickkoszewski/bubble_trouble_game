import 'dart:async';

import 'package:bubble_trouble_game/ball.dart';
import 'package:bubble_trouble_game/button.dart';
import 'package:bubble_trouble_game/missile.dart';
import 'package:bubble_trouble_game/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // player variables
  static double playerX = 0;

  // missile variables
  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  // ball variables
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  // START GAME
  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60; //how strong the jump is

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // quadratic equation that models a bounce (upside down parabola)
      height = -5 * time * time + velocity * time;

      // if the ball reaches the ground, reset jump
      if (height < 0) {
        time = 0;
      }

      // update the ball position
      setState(() {
        ballY = heightToPosition(height);
      });

      //if we touch left wall change direction to right
      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
        //if we touch right wall change direction to left
      } else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }

      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.005;
        });
      }

      //check if the ball hits player
      if (playerDies()) {
        timer.cancel();
        _showDialog();
      }

      // keep the time going!
      time += 0.1;
    });
  }

  // GAME OVER
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: const Center(
              child: Text(
                'You Are DEAD!!!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  // zapis playerX -= 0.1; == playerX = playerX - 0.1;
  // to not go of screen
  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        //do nothing
      } else {
        playerX -= 0.1;
      }

      // only make the X coordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        //do nothing
      } else {
        playerX += 0.1;
      }
      // only make the X coordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  // 3/4 ponieważ różowa część ekranu jest ustawiona na flex:3
  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        // shots fired
        midShot = true;

        // missile grows til it hits the top of the screen
        setState(() {
          missileHeight += 10;
        });

        // stop missile when it reaches top of screen
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        // chcek if miisile has hit the ball
        if (ballY > heightToPosition(missileHeight) &&
            (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

  // converts height to Position
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 0;
    midShot = false;
  }

  bool playerDies() {
    // if ball position and player position are the same, player dies
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
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
                    MyBall(
                      ballX: ballX,
                      ballY: ballY,
                    ),
                    MyMissile(
                      height: missileHeight,
                      missileX: missileX,
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
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
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
