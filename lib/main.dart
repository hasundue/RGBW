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
            const Padding(
              padding: EdgeInsets.all(50.0),
              child: Discards(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                OpponCards(),
                FieldCards(),
                PlayerCards(),
                DeckCards(),
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
    ref.read(discardsProvider.state).state = [];
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
    List<Color> cards = ref.watch(playerCardsProvider);
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
      onAccept: (Color data) {
        ref.read(playerCardsProvider).add(data);
        ref.read(deckProvider.notifier).deal(1);
      },
    );
  }
}

class OpponCard extends ConsumerWidget {
  const OpponCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final Color color = ref.watch(opponCardsProvider)[id];
    return ColoredCard(color: color, facedown: true, size: deviceSize);
  }
}

class PlayerCard extends ConsumerWidget {
  const PlayerCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final Color color = ref.watch(playerCardsProvider)[id];
    return Draggable(
      data: {'id': id, 'color': color},
      child: ColoredCard(color: color, size: deviceSize),
      feedback: ColoredCard(color: color, size: deviceSize),
      childWhenDragging: DummyCard(size: deviceSize),
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        if (velocity != Velocity.zero && color != Colors.white) {
          ref.read(playerCardsProvider.notifier).update((state) => state.removeCard(id));
          ref.read(discardsProvider.notifier).update((state) => state.addCard(color));
        }
      },
    );
  }
}

class FieldCard extends ConsumerWidget {
  const FieldCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    Color color = ref.watch(fieldCardsProvider)[id];
    return DragTarget(
      builder: (context, accepted, rejected) {
        return ColoredCard(color: color, size: deviceSize);
      },
      onAccept: (Map data) {
        if (data['color'] != color) {
          ref.read(playerCardsProvider.notifier).update((state) => state.replace(data['id'], color));
          color = data['color'];
          // Move to opponent't turn
        }
      },
    );
  }
}

class DeckCards extends ConsumerWidget {
  const DeckCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final List<Color> deck = List.from(ref.watch(deckProvider).reversed);
    final int nCards = deck.length;

    if (deck.isNotEmpty) {
      return Row(
        children: [
          Stack(
            children: [
              for (var i = 0; i < deck.length - 1; i++)
              ColoredCard(color: deck[i], size: deviceSize, facedown: true),
              Draggable(
                data: deck.last,
                child: ColoredCard(color: deck.last, size: deviceSize, facedown: true),
                feedback: ColoredCard(color: deck.last, size: deviceSize, facedown: true),
                childWhenDragging: DummyCard(size: deviceSize),
              ),
            ],
          ),
          Text(
            deck.length.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ],
      );
    } else {
      return DummyCard(size: deviceSize);
    }
  }
}

class Discards extends ConsumerWidget {
  const Discards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;

    final List<Color> cards = ref.watch(discardsProvider);

    final List<Color> red = cards.where((card) => card == Colors.red).toList();
    final List<Color> green = cards.where((card) => card == Colors.green).toList();
    final List<Color> black = cards.where((card) => card == Colors.black).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var color in [red, green, black])
          if (color.isNotEmpty)
            Row(
              children: [ 
                Stack(
                  children: [
                    for (var i = 0; i < color.length; i++)
                      ColoredCard(color: color[0], size: deviceSize, rotated: true),
                  ],
                ),
                Text(
                  color.length.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
      ],
    );
  }
}
