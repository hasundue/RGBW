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

extension Game on GameCards {
  GameCards replaced(int i, GameCard card) {
    GameCards cards = [...this];
    cards.replaceRange(i, i+1, [card]);
    return cards;
  }

  GameCards added(GameCard card) {
    GameCards cards = [...this];
    cards.add(card);
    return cards;
  }
  
  GameCards removed(int i) {
    GameCards cards = [...this];
    cards.removeAt(i);
    return cards;
  } 
}

class GameStateForAlice {
  GameCards alice;
  GameCards field;
  GameCards discard;
  
  GameStateForAlice(this.alice, this.field, this.discard);

  GameStateForAlice getNewState(AliceMove move) {
    return GameStateForAlice(
      alice.replaced(move.aliceCardId, field[move.fieldCardId]),
      field.replaced(move.fieldCardId, alice[move.aliceCardId]),
      discard,
    );
  }
}

class AliceMove {
  int aliceCardId;
  int fieldCardId;

  AliceMove(this.aliceCardId, this.fieldCardId);
}

typedef AliceMoves = List<AliceMove>;

AliceMove getAliceMove(GameStateForAlice state) {
  AliceMoves legal = getLegalMoves(state);
  // List<GameStateForAlice> newStates = legal.map((move) => state.getNewState(move)).toList();

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
