import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class Deck extends StateNotifier<List<Color>> {
  Deck() : super(initDeck());

  void init() {
    state = initDeck();
  }

  List<Color> deal(int n) {
    var dealed = state.sublist(0, n);
    state = state.sublist(n);
    return dealed;
  }
}

List<Color> initDeck() {
  List<Color> cards = List.filled(6, Colors.red);
  cards += List.filled(6, Colors.green);
  cards += List.filled(6, Colors.black);
  cards += List.filled(2, Colors.white);
  cards.shuffle();
  return cards;
}

const List<Color> initialCards = [Colors.red, Colors.green, Colors.black, Colors.white];
