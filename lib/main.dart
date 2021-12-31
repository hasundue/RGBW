import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:RGBW/card.dart';
import 'package:RGBW/game.dart';

final gamePhaseProvider = StateProvider<GamePhase>((ref) => GamePhase.setup);
final deckProvider = StateNotifierProvider<DeckNotifier, GameCards>((ref) => DeckNotifier());
final playerCardsProvider = StateProvider<GameCards>((ref) => []);
final aliceCardsProvider = StateProvider<GameCards>((ref) => []);
final fieldCardsProvider = StateProvider<GameCards>((ref) => []);
final discardsProvider = StateProvider<GameCards>((ref) => []);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGBW',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RGBW - Red Green Black and White'),
      ),
      body: Center(
        child: Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const AliceCards(),
                const FieldCards(),
                const PlayerCards(),
                Row (
                  children: const [
                    Discards(),
                    DeckCards(),
                  ],
                ), // Row
              ],
            ), // Column
          ],
        ), // Row
      ), // Center
      floatingActionButton: FloatingActionButton (
        onPressed: () => initGame(ref),
        child: const Icon(Icons.play_arrow_rounded)
      ),
    ); // Scaffold
  } // build

  void initGame(WidgetRef ref) {
    final DeckNotifier deck = ref.read(deckProvider.notifier);
    deck.init();
    for (var provider in [aliceCardsProvider, fieldCardsProvider, playerCardsProvider]) {
      ref.read(provider.notifier).state = deck.deal(4);
    }
    ref.read(discardsProvider.notifier).state = [];
    ref.read(gamePhaseProvider.notifier).state = GamePhase.draw;
  }
}

class AliceCards extends ConsumerWidget {
  const AliceCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameCards cards = ref.watch(aliceCardsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < cards.length; i++)
          AliceCard(id: i),
      ],
    );
  }
}

class FieldCards extends ConsumerWidget {
  const FieldCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameCards cards = ref.watch(fieldCardsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < cards.length; i++)
          FieldCard(id: i),
      ],
    );
  }
}

class PlayerCards extends ConsumerWidget {
  const PlayerCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameCards cards = ref.watch(playerCardsProvider);
    return DragTarget(
      builder: (context, accepted, rejected) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < cards.length; i++)
            PlayerCard(id: i),
          ],
        );
      },
      onAccept: (GameCard data) {
        ref.read(playerCardsProvider).add(data);
        ref.read(deckProvider.notifier).deal(1);
        ref.read(gamePhaseProvider.notifier).state = GamePhase.discard;
      },
    );
  }
}

class AliceCard extends ConsumerWidget {
  const AliceCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final GameCard card = ref.watch(aliceCardsProvider)[id];
    return ColoredCard(color: card.color(), facedown: true, size: deviceSize);
  }
}

class PlayerCard extends ConsumerWidget {
  const PlayerCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final GameCard card = ref.watch(playerCardsProvider)[id];

    return Draggable(
      data: {'id': id, 'color': card},
      child: ColoredCard(color: card.color(), size: deviceSize),
      feedback: ColoredCard(color: card.color(), size: deviceSize),
      childWhenDragging: DummyCard(size: deviceSize),
    );
  }
}

class FieldCard extends ConsumerWidget {
  const FieldCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final GamePhase phase = ref.watch(gamePhaseProvider);
    final GameCard card = ref.watch(fieldCardsProvider)[id];

    if (phase == GamePhase.replace) {
      return DragTarget(
        builder: (context, accepted, rejected) {
          return ColoredCard(color: card.color(), size: deviceSize);
        },
        onAccept: (Map data) {
          if (data['color'] != card.color()) {
            ref.read(playerCardsProvider.notifier).update(
              (state) {
                return state.replaceCard(data['id'], card);
              }
            );
            ref.read(fieldCardsProvider.notifier).update(
              (state) {
                return state.replaceCard(id, data['color']);
              }
            );
            ref.read(gamePhaseProvider.notifier).state = GamePhase.draw;
          }
        },
      );
    } else {
      return ColoredCard(color: card.color(), size: deviceSize);
    }
  }
}

class DeckCards extends ConsumerWidget {
  const DeckCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final GamePhase phase = ref.watch(gamePhaseProvider);
    final GameCards deck = List.from(ref.watch(deckProvider).reversed);

    if (deck.isNotEmpty) {
      return Row(
        children: [
          Stack(
            children: [
              for (var i = 0; i < deck.length - 1; i++)
                ColoredCard(color: deck[i].color(), size: deviceSize, facedown: true),
              if (phase == GamePhase.draw)
                Draggable(
                  data: deck.last,
                  child: ColoredCard(color: deck.last.color(), size: deviceSize, facedown: true),
                  feedback: ColoredCard(color: deck.last.color(), size: deviceSize, facedown: true),
                  childWhenDragging: DummyCard(size: deviceSize),
                ),
              if (phase != GamePhase.draw)
                ColoredCard(color: deck.last.color(), size: deviceSize, facedown: true),
            ],
          ),
          Text(
            deck.length.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ); // Row
    } else {
      return DummyCard(size: deviceSize);
    }
  } // build
}

class Discards extends ConsumerWidget {
  const Discards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final GamePhase phase = ref.watch(gamePhaseProvider);

    final GameCards cards = ref.watch(discardsProvider);

    final GameCards red = cards.where((card) => card == GameCard.red).toList();
    final GameCards green = cards.where((card) => card == GameCard.green).toList();
    final GameCards black = cards.where((card) => card == GameCard.black).toList();

    return DragTarget(
      builder: (context, accepted, rejected) {
        return Row(
          children: [
            for (var color in [red, green, black])
              Row(
                children: [ 
                  Stack(
                    children: [
                      DummyCard(size: deviceSize),
                      for (var i = 0; i < color.length; i++)
                        ColoredCard(color: color[0].color(), size: deviceSize),
                    ],
                  ),
                  if (color.isNotEmpty)
                    Text(
                      color.length.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                ],
              ), // Row
          ],
        ); // Row
      }, // builder
      onAccept: (Map data) {
        if (phase == GamePhase.discard) {
          ref.read(playerCardsProvider.notifier).update((state) => state.removeCard(data['id']));
          ref.read(discardsProvider.notifier).update((state) => state.addCard(data['color']));
          ref.read(gamePhaseProvider.notifier).state = GamePhase.replace;
        }
      },
    ); // DragTarget
  } // Widget
}
