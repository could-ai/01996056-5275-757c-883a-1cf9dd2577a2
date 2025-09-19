import 'dart:async';
import 'package:flutter/material.dart';
import 'package:couldai_user_app/player.dart';
import 'package:couldai_user_app/obstacle.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  static const double playerWidth = 80.0;
  static const double playerHeight = 80.0;
  double playerX = 0; // -1 for left, 0 for middle, 1 for right
  
  double obstacleX = 0;
  double obstacleY = -1.5;
  double obstacleWidth = 100.0;
  double obstacleHeight = 100.0;

  int score = 0;
  bool isPlaying = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    )..addListener(_gameLoop);
  }

  void _startGame() {
    if (_controller.isAnimating) {
      return;
    }
    setState(() {
      isPlaying = true;
      playerX = 0;
      obstacleY = -1.5;
      score = 0;
      _generateRandomObstacle();
    });
    _controller.repeat();
  }

  void _gameLoop() {
    if (!isPlaying) return;

    setState(() {
      obstacleY += 0.01;
      if (obstacleY > 1.5) {
        obstacleY = -1.5;
        score++;
        _generateRandomObstacle();
      }

      // Collision detection
      if (obstacleY > 0.6 &&
          (playerX * 150 - playerWidth / 2 < obstacleX * 150 + obstacleWidth / 2) &&
          (playerX * 150 + playerWidth / 2 > obstacleX * 150 - obstacleWidth / 2)) {
        _gameOver();
      }
    });
  }
  
  void _generateRandomObstacle() {
      // For now, let's keep it simple
      obstacleX = ([-1, 0, 1]..shuffle()).first.toDouble();
  }

  void _gameOver() {
    _controller.stop();
    setState(() {
      isPlaying = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _movePlayer(DragUpdateDetails details) {
    if (!isPlaying) return;
    setState(() {
      playerX += details.delta.dx / (MediaQuery.of(context).size.width / 3);
      if (playerX > 1) playerX = 1;
      if (playerX < -1) playerX = -1;
    });
  }
  
  void _onHorizontalDragEnd(DragEndDetails details) {
    if (playerX.abs() < 0.5) {
        setState(() {
            playerX = 0;
        });
    } else {
        setState(() {
            playerX = playerX > 0 ? 1 : -1;
        });
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: _movePlayer,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          children: [
            // Background (lanes)
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(child: Container(color: Colors.grey[300])),
                  Expanded(child: Container(color: Colors.grey[400])),
                  Expanded(child: Container(color: Colors.grey[300])),
                ],
              ),
            ),
            
            // Player
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              alignment: Alignment(playerX, 0.8),
              child: const Player(
                width: playerWidth,
                height: playerHeight,
              ),
            ),

            // Obstacle
            if (isPlaying)
              AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                alignment: Alignment(obstacleX, obstacleY),
                child: Obstacle(
                  width: obstacleWidth,
                  height: obstacleHeight,
                ),
              ),

            // Score
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Start Button
            if (!isPlaying)
              Center(
                child: ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('Start Game', style: TextStyle(fontSize: 20)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
