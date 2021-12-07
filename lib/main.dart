import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rgbw/card.dart';
import 'package:rgbw/game.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final deckProvider = StateNotifierProvider<Deck, List<Color>>((ref) => Deck());

final playerCardsProvider = StateProvider<List<Color>>((ref) => []);

final opponCardsProvider = StateProvider<List<Color>>((ref) => []);

final fieldCardsProvider = StateProvider<List<Color>>((ref) => []);

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [ 
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                DeckCards(),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton (
          onPressed: () {
            final Deck deck = ref.read(deckProvider.notifier);
            deck.init();
            ref.read(playerCardsProvider.state).state = deck.deal(4);
            ref.read(opponCardsProvider.state).state = deck.deal(4);
            ref.read(fieldCardsProvider.state).state = deck.deal(4);
          },
          child: const Icon(Icons.play_arrow_rounded)
      ),
    );
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

class DeckCards extends ConsumerWidget {
  const DeckCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Color> deck = ref.watch(deckProvider);
    var reversedDeck = List.from(deck.reversed);
    return Stack(
      children: [
        for (var i = 0; i < reversedDeck.length; i++)
          ColoredCard(color: reversedDeck[i], facedown: true),
      ],
    );
  }
}
