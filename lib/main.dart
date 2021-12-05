import 'package:flutter/material.dart';
import 'package:rgbw/card.dart';
import 'package:rgbw/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGBW',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'RGBW - Red Green Black and White'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  GameState _gamestate = GameState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Cards in the opponent's hand
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColoredCard(color: Colors.blue),
                ColoredCard(color: Colors.blue),
                ColoredCard(color: Colors.blue),
                ColoredCard(color: Colors.blue),
              ],
            ),
            // Cards in the field
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColoredCard(color: Colors.red),
                ColoredCard(color: Colors.green),
                ColoredCard(color: Colors.black),
                ColoredCard(color: Colors.white),
              ],
            ),
            // Cards in the player's hand
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColoredCard(color: Colors.red),
                ColoredCard(color: Colors.green),
                ColoredCard(color: Colors.black),
                ColoredCard(color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
