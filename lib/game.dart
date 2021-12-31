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

  AlicePlay alicePlay() {
    var rand = Random();
    return AlicePlay(rand.nextInt(4), rand.nextInt(4));
  }
}

class AlicePlay {
  int aliceCardId;
  int fieldCardId;

  AlicePlay(this.aliceCardId, this.fieldCardId);
}
