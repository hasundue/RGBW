import 'package:test/test.dart';
import 'package:RGBW/game.dart';

void main() {

  group('composition', () {
    test('all 1', () {
      GameCards cards = [GameCard.red, GameCard.green, GameCard.black, GameCard.white];
      List<int> comp = cards.composition();
      expect(comp, [1,1,1,1]);
    });
    test('red only', () {
      GameCards cards = List.filled(4, GameCard.red);
      List<int> comp = cards.composition();
      expect(comp, [4,0,0,0]);
    });
  });

  group('diff', () {
    test('identical', () {
      GameCards cards = [GameCard.red, GameCard.green, GameCard.black, GameCard.white];
      GameCards diff = cards.diff(cards);
      expect(diff, []);
    });
    test('one difference', () {
      GameCards cards1 = [GameCard.red, GameCard.green, GameCard.black, GameCard.white];
      GameCards cards2 = [GameCard.red, GameCard.green, GameCard.black, GameCard.black];
      GameCards diff = cards1.diff(cards2);
      expect(diff, [GameCard.black]);
    });
  });

  group('isMatched', () {
    test('identical without white', () {
      GameCards cards = [GameCard.red, GameCard.green, GameCard.black, GameCard.black];
      bool isMatched = cards.isMatched(cards);
      expect(isMatched, true);
    });
    test('identical with white', () {
      GameCards cards = [GameCard.red, GameCard.green, GameCard.black, GameCard.white];
      bool isMatched = cards.isMatched(cards);
      expect(isMatched, false);
    });
    test('match with white', () {
      GameCards hand = [GameCard.red, GameCard.green, GameCard.black, GameCard.black];
      GameCards field = [GameCard.red, GameCard.green, GameCard.black, GameCard.white];
      bool isMatched = hand.isMatched(field);
      expect(isMatched, true);
    });
    test('unmatch with white', () {
      GameCards hand = [GameCard.red, GameCard.red, GameCard.black, GameCard.black];
      GameCards field = [GameCard.red, GameCard.green, GameCard.black, GameCard.white];
      bool isMatched = hand.isMatched(field);
      expect(isMatched, false);
    });
  });

}
