import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisedondsText = "";
  GameState gameState = GameState.readyToStart;
  static const Color startButtonColor = Color(0xFF40CA88);
  static const Color waitingButtonColor = Color(0xFFE0982D);
  static const Color canBeStoppedButtonColor = Color(0xFFE02D47);

  Color buttonColor = startButtonColor;

  Timer? _watingTimer = null;
  Timer? _stoppingTimer = null;

  @override
  void dispose() {
    super.dispose();
    _watingTimer?.cancel();
    _stoppingTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Color(0xFF282E3D),
        // color: Colors.white,
        child: Stack(
          children: [
            const Align(
              alignment: Alignment(0, -0.8),
              child: Text(
                "Test your\nreaction speed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.black,
                  fontSize: 38,
                  fontWeight: FontWeight.w900
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: Color(0xFF6D6D6D),
                child: SizedBox(
                  width: 250,
                  height: 160,
                  child: Center(
                    child: Text(
                      millisedondsText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.8),
              child: GestureDetector(
                onTap: () => setState(() {
                  switch (gameState) {
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      buttonColor = waitingButtonColor;
                      _startWaitingTimer();
                      millisedondsText = "";
                      break;
                    case GameState.waiting:
                      break;
                    case GameState.canBeStopped:
                      _stoppingTimer?.cancel();
                      buttonColor = startButtonColor;
                      gameState = GameState.readyToStart;
                      break;
                  }
                }),
                child: ColoredBox(
                  color: buttonColor,
                  child: SizedBox(
                    height: 160,
                    width: 160,
                    child: Center(
                      child: Text(
                        getButtonText(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            decorationColor: Colors.black,
                            fontSize: 38,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return 'START';
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
    return '';
  }

  void _startWaitingTimer() {
    _watingTimer?.cancel();
    _watingTimer =
        Timer(Duration(milliseconds: Random().nextInt(4000) + 1500), () {
      setState(() {
        gameState = GameState.canBeStopped;
        buttonColor = canBeStoppedButtonColor;

      });
      _startStoppingTimer();
    });
  }

  void _startStoppingTimer() {
    _stoppingTimer?.cancel();
    _stoppingTimer = Timer.periodic(
        Duration(
          milliseconds: 17,
        ), (timer) {
      setState(() {
        millisedondsText = "${timer.tick * 17} ms";
      });
    });
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
