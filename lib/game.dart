import 'dart:math';

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

  AliceMove alicePlay() {
    var rand = Random();
    return AliceMove(rand.nextInt(4), rand.nextInt(4));
  }
}

class AliceMove {
  int aliceCardId;
  int fieldCardId;

  AliceMove(this.aliceCardId, this.fieldCardId);
}

typedef AliceMoves = List<AliceMove>;
