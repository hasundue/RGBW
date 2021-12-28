import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:RGBW/card.dart';
import 'package:RGBW/game.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final deckProvider = StateNotifierProvider<Deck, List<Color>>((ref) => Deck());
final playerCardsProvider = StateProvider<List<Color>>((ref) => []);
final opponCardsProvider = StateProvider<List<Color>>((ref) => []);
final fieldCardsProvider = StateProvider<List<Color>>((ref) => []);
final discardsProvider = StateProvider<List<Color>>((ref) => []);

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
              children: const [
                DummyCard(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                OpponCards(),
                FieldCards(),
                PlayerCards(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const DummyCard(),
                const DummyCard(),
                Row(
                  children: const [
                    DummyCard(),
                    DeckCards(),
                  ]
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton (
          onPressed: () => initGame(ref),
          child: const Icon(Icons.play_arrow_rounded)
      ),
    );
  }

  void initGame(WidgetRef ref) {
    final Deck deck = ref.read(deckProvider.notifier);
    deck.init();
    ref.read(playerCardsProvider.state).state = deck.deal(4);
    ref.read(opponCardsProvider.state).state = deck.deal(4);
    ref.read(fieldCardsProvider.state).state = deck.deal(4);
  }
}

class OpponCards extends ConsumerWidget {
  const OpponCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Color> cards = ref.watch(opponCardsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < cards.length; i++)
          OpponCard(id: i),
      ],
    );
  }
}

class FieldCards extends ConsumerWidget {
  const FieldCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Color> cards = ref.watch(fieldCardsProvider);
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
    final List<Color> cards = ref.watch(playerCardsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < cards.length; i++)
          PlayerCard(id: i),
      ],
    );
  }
}

class OpponCard extends ConsumerWidget {
  const OpponCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = ref.watch(opponCardsProvider)[id];
    return ColoredCard(color: color, facedown: true);
  }
}

class PlayerCard extends ConsumerWidget {
  const PlayerCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = ref.watch(playerCardsProvider)[id];
    return Draggable(
      data: {'id': id, 'color': color},
      child: ColoredCard(color: color),
      feedback: ColoredCard(color: color),
      childWhenDragging: const DummyCard(),
    );
  }
}

class FieldCard extends ConsumerWidget {
  const FieldCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color color = ref.watch(fieldCardsProvider)[id];
    return DragTarget(
      builder: (context, accepted, rejected) {
        return ColoredCard(color: color);
      },
      onAccept: (Map data) {
        ref.read(playerCardsProvider)[data['id']] = color;
        color = data['color'];
      },
    );
  }
}

class DeckCards extends ConsumerWidget {
  const DeckCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Color> deck = List.from(ref.watch(deckProvider).reversed);
    return Stack(
      children: [
        for (var i = 0; i < deck.length - 1; i++)
          ColoredCard(color: deck[i], facedown: true),
        Draggable(
          child: ColoredCard(color: deck.last, facedown: true),
          feedback: ColoredCard(color: deck.last, facedown: true),
          childWhenDragging: const DummyCard(),
        ),
      ],
    );
  }
}

class Discards extends ConsumerWidget {
  const Discards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Color> cards = ref.watch(discardsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < cards.length; i++)
          FieldCard(id: i),
      ],
    );
  }
}
