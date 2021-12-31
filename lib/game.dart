const int handSize = 4;

enum GamePhase {
  setup,
  draw,
  discard,
  replace,
  alice,
}

enum GameCard {
  red,
  green,
  black,
  white,
}

typedef GameCards = List<GameCard>;

class GameStateForAlice {
  GameCards alice;
  GameCards field;
  GameCards discard;
  
  GameStateForAlice(this.alice, this.field, this.discard);
}

class AliceMove {
  int aliceCardId;
  int fieldCardId;

  AliceMove(this.aliceCardId, this.fieldCardId);
}

typedef AliceMoves = List<AliceMove>;

AliceMove getAliceMove(GameStateForAlice state) {
  AliceMoves legal = getLegalMoves(state);

  legal.shuffle();

  return legal.first;
}

AliceMoves getLegalMoves(GameStateForAlice state) {
  GameCards alice = state.alice;
  GameCards field = state.field;

  AliceMoves moves = [];

  for (int i = 0; i < handSize; i++) {
    for (int j = 0; j < handSize; j++) {
      if (alice[i] != field[j]) {
        moves.add(AliceMove(i, j));
      }
    }
  }
  return moves;
}
