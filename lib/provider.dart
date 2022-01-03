import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:RGBW/game.dart';

final gamePhaseProvider = StateProvider<GamePhase>((ref) => GamePhase.setup);
final deckProvider = StateNotifierProvider<DeckNotifier, GameCards>((ref) => DeckNotifier());
final playerCardsProvider = StateProvider<GameCards>((ref) => []);
final aliceCardsProvider = StateProvider<GameCards>((ref) => []);
final fieldCardsProvider = StateProvider<GameCards>((ref) => []);
final discardsProvider = StateProvider<GameCards>((ref) => []);

class DeckNotifier extends StateNotifier<GameCards> {
  DeckNotifier() : super([]);

  void init() {
    GameCards deck = List.filled(6, GameCard.red);
    deck += List.filled(6, GameCard.green);
    deck += List.filled(6, GameCard.black);
    deck += List.filled(2, GameCard.white);
    deck.shuffle();
    state = deck;
  }

  GameCards deal(int n) {
    var dealed = state.sublist(0, n);
    state = state.sublist(n);
    return dealed;
  }
}

class PlayerCards extends StateNotifier<GameCards> {
  PlayerCards() : super([]);

  void replace(int id, GameCard card) {
    state[id] = card;
  }
}
