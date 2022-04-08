import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:RGBW/game.dart';

final gamePhaseProvider = StateProvider<GamePhase>((ref) => GamePhase.setup);

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) =>
    GameStateNotifier()
);

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState([], [], [], [], []));

  void init() {
    GameCards deck = List.filled(6, GameCard.red);
    deck += List.filled(6, GameCard.green);
    deck += List.filled(6, GameCard.black);
    deck += List.filled(2, GameCard.white);
    deck.shuffle();

    state = GameState(deck, [], [], [], []);

    dealToAlice(handSize);
    dealToField(handSize);
    dealToPlayer(handSize);
  }

  void dealToAlice(int n) {
    state = state.copyWith(
      deck: state.deck.sublist(n), 
      alice: state.deck.sublist(0, n)
    );
  }

  void dealToField(int n) {
    state = state.copyWith(
      deck: state.deck.sublist(n), 
      field: state.deck.sublist(0, n)
    );
  }

  void dealToPlayer(int n) {
    state = state.copyWith(
      deck: state.deck.sublist(n),
      player: state.deck.sublist(0, n)
    );
  }

  void draw() {
    state = state.copyWith(
      deck: state.deck.sublist(1),
      player: state.player.added(state.deck[0])
    );
  }

  void discard(int i) {
    state = state.copyWith(
      player: state.player.removed(i),
      discard: state.discard.added(state.player[i])
    );
  }

  void exchangeAlice(int alice, int field) {
    state = state.copyWith(
      alice: state.player.replaced(alice, state.field[field]),
      field: state.player.replaced(field, state.alice[alice])
    );
  }

  void exchangePlayer(int playerCardNum, int fieldCardNum) {
    state = state.copyWith(
      player: state.player.replaced(playerCardNum, state.field[fieldCardNum]),
      field: state.player.replaced(fieldCardNum, state.player[playerCardNum])
    );
  }
}
