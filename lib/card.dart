import 'package:flutter/material.dart';

const heightRatio = 0.12;
const widthRatio = heightRatio * 0.8;

class ColoredCard extends SizedBox {
  ColoredCard({Key? key,
               Color color = Colors.blue,
               Size size = const Size(1280, 800),
               bool facedown = false,
               bool rotated = false})
  : super(
    key: key,
    child: Card(
      color: facedown ? Colors.blue : color,
      elevation: 2,
    ),
    width: size.height * (rotated ? heightRatio : widthRatio),
    height: size.height * (rotated ? widthRatio : heightRatio),
  );
}

@immutable
class DummyCard extends SizedBox {
  DummyCard({Key? key, Size size = const Size(1280, 800)}) : super(
    key: key,
    width: size.height * widthRatio,
    height: size.height * heightRatio,
  );
}
