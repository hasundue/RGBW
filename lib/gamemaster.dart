import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:RGBW/game.dart';
import 'package:RGBW/provider.dart';

extension GameMaster on WidgetRef {
  void setGameMaster() {
    listen<GamePhase>(gamePhaseProvider, (GamePhase? previousPhase, GamePhase newPhase) {
      if (newPhase == GamePhase.alice) {
        GameCards alice = read(gameStateProvider).alice;
        GameCards field = read(gameStateProvider);
        GameCards discards = read(discardsProvider);

        GameStateForAlice state = GameStateForAlice(alice, field, discards);

        // Is Alice winner?
        if (isAliceWinner(state)) {
          read(gamePhaseProvider.notifier).state = GamePhase.aliceWin;
        }
        else {
          // Alice's move
          AliceMove move = getAliceMove(state);

          GameCard aliceCard = alice[move.aliceCardId];
          GameCard fieldCard = field[move.fieldCardId];

          read(gameStateProvider.notifier).update((state) =>
              state.replaced(move.fieldCardId, aliceCard)
          );
          read(gameStateProvider.notifier).update((state) =>
              state.replaced(move.aliceCardId, fieldCard)
          );

          // Is player winner?
          GameCards player = read(playerCardsProvider);
          GameCards newField = read(gameStateProvider);
          GameCards newDiscards = read(discardsProvider);
          GameStateForPlayer playerstate = GameStateForPlayer(player, newField, newDiscards);

          if (isPlayerWinner(playerstate)) {
            read(gamePhaseProvider.notifier).state = GamePhase.playerWin;
          }
          else {
            read(gamePhaseProvider.notifier).state = GamePhase.draw;
          }
        }
      }
    }); // listen
  } // method
}
