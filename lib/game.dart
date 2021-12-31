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
  GameCards replaceCard(int i, GameCard card) {
    GameCards cards = [];
    for (var j = 0; j < length; j++) {
      if (j == i) {
        cards.add(card);
      } else {
        cards.add(this[j]);
      }
    }
    return cards;
  }

  GameCards addCard(GameCard card) {
    GameCards cards = [];
    for (var j = 0; j < length; j++) {
      cards.add(this[j]);
    }
    cards.add(card);
    return cards;
  }
  
  GameCards removeCard(int i) {
    GameCards cards = [];
    for (var j = 0; j < length; j++) {
      if (j != i) {
        cards.add(this[j]);
      }
    }
    return cards;
  } 
}
