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
  List<Color> _deck = [];
  List<Color> _field = [];
  List<Color> _hand1 = [];
  List<Color> _hand2 = [];

  void _initGame() {
    setState(() {
      _deck = initDeck();
      _field = serve(_deck, 4);
      _hand1 = serve(_deck, 4);
      _hand2 = serve(_deck, 4);
    });
  }

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
                if (_hand2.isNotEmpty) ColoredCard(color: Colors.blue),
                if (_hand2.length > 1) ColoredCard(color: Colors.blue),
                if (_hand2.length > 2) ColoredCard(color: Colors.blue),
                if (_hand2.length > 3) ColoredCard(color: Colors.blue),
              ],
            ),
            // Cards in the field
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_field.isNotEmpty) ColoredCard(color: _field[0]),
                if (_field.length > 1) ColoredCard(color: _field[1]),
                if (_field.length > 2) ColoredCard(color: _field[2]),
                if (_field.length > 3) ColoredCard(color: _field[3]),
              ],
            ),
            // Cards in the player's hand
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_hand1.isNotEmpty) ColoredCard(color: _hand1[0]),
                if (_hand1.length > 1) ColoredCard(color: _hand1[1]),
                if (_hand1.length > 2) ColoredCard(color: _hand1[2]),
                if (_hand1.length > 3) ColoredCard(color: _hand1[3]),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton (
          onPressed: () => _initGame(),
          child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
