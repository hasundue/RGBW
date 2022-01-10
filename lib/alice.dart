import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:RGBW/game.dart';
import 'package:RGBW/provider.dart';

class Alice extends ConsumerWidget {
  const Alice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final GamePhase phase = ref.watch(gamePhaseProvider);

    return Column(
      children: [
        Icon(
          aliceFace(phase),
          color: Colors.blue,
          size: deviceSize.height * 0.08,
        ),
        Text(
          aliceMessage(phase),
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  IconData aliceFace(GamePhase phase) {
    switch (phase) {
      case GamePhase.aliceWin:
        return Icons.sentiment_very_satisfied_outlined;
      case GamePhase.playerWin:
        return Icons.sentiment_satisfied_alt;
      default:
        return Icons.sentiment_satisfied;
    }
  }

  String aliceMessage(GamePhase phase) {
    switch (phase) {
      case GamePhase.aliceWin:
        return 'I won!';
      case GamePhase.playerWin:
        return 'You won!';
      default:
        return '';
    }
  }
}

