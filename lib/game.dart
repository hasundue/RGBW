import 'package:flutter/material.dart';

List<Color> initDeck() {
  List<Color> cards = List.filled(6, Colors.red);
  cards += List.filled(6, Colors.green);
  cards += List.filled(6, Colors.black);
  cards += List.filled(2, Colors.white);
  cards.shuffle();
  return cards;
}

List<Color> serve(List<Color> cards, int n) {
  var served = cards.sublist(0, n);
  cards.removeRange(0, n);
  return served;
}
