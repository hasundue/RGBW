import 'package:flutter/material.dart';

const widthRatio = 0.1;
const heightRatio = 0.12;

class ColoredCard extends SizedBox {
  ColoredCard({Key? key,
               Color color = Colors.blue,
               Size size = const Size(1280, 800),
               bool facedown = false})
  : super(
    key: key,
    child: Card(
      color: facedown ? Colors.blue : color,
      elevation: 2,
    ),
    width: size.width * widthRatio,
    height: size.width * heightRatio,
  );
}

@immutable
class DummyCard extends SizedBox {
  DummyCard({Key? key, Size size = const Size(1280, 800)}) : super(
    key: key,
    width: size.width * widthRatio,
    height: size.width * heightRatio,
  );
}
