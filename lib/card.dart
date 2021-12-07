import 'package:flutter/material.dart';

class ColoredCard extends SizedBox {
  ColoredCard({Key? key,
               Color color = Colors.blue,
               bool facedown = false})
  : super(
    key: key,
    child: Card(
      color: facedown ? Colors.blue : color,
      elevation: 2,
    ),
    width: 60,
    height: 80,
  );
}

@immutable
class DummyCard extends SizedBox {
  const DummyCard({Key? key}) : super(
    key: key,
    width: 60,
    height: 80,
  );
}
