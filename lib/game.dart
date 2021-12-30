import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

enum GamePhase {
  setup,
  draw,
  discard,
  replace,
  alice,
}

class Deck extends StateNotifier<List<Color>> {
  Deck() : super([]);

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

class PlayerCards extends StateNotifier<List<Color>> {
  PlayerCards() : super([]);

  void replace(int id, Color color) {
    state[id] = color;
  }
}

extension Game on List<Color> {
  List<Color> replace(int i, Color x) {
    List<Color> list = [];
    for (var j = 0; j < length; j++) {
      if (j == i) {
        list.add(x);
      } else {
        list.add(this[j]);
      }
    }
    return list;
  }

  List<Color> addCard(Color x) {
    List<Color> list = [];
    for (var j = 0; j < length; j++) {
      list.add(this[j]);
    }
    list.add(x);
    return list;
  }
  
  List<Color> removeCard(int i) {
    List<Color> list = [];
    for (var j = 0; j < length; j++) {
      if (j != i) {
        list.add(this[j]);
      }
    }
    return list;
  } 
}
