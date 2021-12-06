import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rgbw/card.dart';
import 'package:rgbw/game.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final deckProvider = StateNotifierProvider<Deck, List<Color>>((ref) => Deck());

final playerCardsProvider = StateProvider<List<Color>>((ref) {
  return ref.watch(deckProvider.notifier).deal(4);
});

final fieldCardsProvider = StateProvider<List<Color>>((ref) {
  return ref.watch(deckProvider.notifier).deal(4);
});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            OpponentCards(),
            FieldCards(),
            PlayerCards(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton (
          onPressed: () {
            final Deck deck = ref.read(deckProvider.notifier);
            deck.init();
            ref.read(playerCardsProvider.state).state = deck.deal(4);
            ref.read(fieldCardsProvider.state).state = deck.deal(4);
          },
          child: const Icon(Icons.play_arrow_rounded)
      ),
    );
  }
}

class OpponentCards extends ConsumerWidget {
  const OpponentCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ColoredCard(color: Colors.blue),
        ColoredCard(color: Colors.blue),
        ColoredCard(color: Colors.blue),
        ColoredCard(color: Colors.blue),
      ],
    );
  }
}

class FieldCards extends ConsumerWidget {
  const FieldCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        FieldCard(id: 0),
        FieldCard(id: 1),
        FieldCard(id: 2),
        FieldCard(id: 3),
      ],
    );
  }
}

class PlayerCards extends ConsumerWidget {
  const PlayerCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        PlayerCard(id: 0),
        PlayerCard(id: 1),
        PlayerCard(id: 2),
        PlayerCard(id: 3),
      ],
    );
  }
}

class PlayerCard extends ConsumerWidget {
  const PlayerCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = ref.watch(playerCardsProvider)[id];
    return Draggable(
      child: ColoredCard(color: color),
      feedback: ColoredCard(color: color),
      childWhenDragging: ColoredCard(color: color.withOpacity(0.5)),
    );
  }
}

class FieldCard extends ConsumerWidget {
  const FieldCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = ref.watch(fieldCardsProvider)[id];
    return DragTarget(
      builder: (context, accepted, rejected) {
        return ColoredCard(color: color);
      },
      // onAccept: (data) => ref.read(fieldColorProvider.notifier).changeState(color),
    );
  }
}
