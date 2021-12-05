import 'package:flutter/material.dart';

class GameState {
  List<Color> deck = [];
  List<Color> hand1 = [];
  List<Color> hand2 = [];
  List<Color> field = [];

  void init() {
    deck = initDeck();
  }
}

List<Color> initDeck() {
  List<Color> cards = List.filled(6, Colors.red);
  cards += List.filled(6, Colors.green);
  cards += List.filled(6, Colors.black);
  cards += List.filled(6, Colors.white);
  cards.shuffle();
  return cards;
}
