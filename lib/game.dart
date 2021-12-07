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
  List<Color> deck = List.filled(6, Colors.red);
  deck += List.filled(6, Colors.green);
  deck += List.filled(6, Colors.black);
  deck += List.filled(2, Colors.white);
  deck.shuffle();
  return deck;
}

