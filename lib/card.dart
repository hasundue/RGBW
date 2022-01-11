import 'package:flutter/material.dart';
import 'package:RGBW/game.dart';

const heightRatio = 0.12;
const widthRatio = heightRatio * 0.8;

@immutable
class ColoredCard extends StatelessWidget {
  final Color color;
  final bool facedown;
  final bool rotated;
  final bool show;

  const ColoredCard({
    Key? key,
    this.color = Colors.blue,
    this.facedown = false,
    this.rotated = false,
    this.show = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final width = deviceSize.height * (rotated ? heightRatio : widthRatio);
    final height = deviceSize.height * (rotated ? widthRatio : heightRatio);

    if (show) {
      return SizedBox(
        width: width,
        height: height,
        child: Card(
          color: facedown ? Colors.blue : color,
          elevation: 2,
        ),
      );
    }
    else {
      return SizedBox(
        width: width,
        height: height,
      );
    }
  }
}

typedef ColorCards = List<Color>;

extension CardToColor on GameCard {
  Color color() {
    switch (this) {
      case GameCard.red:
        return Colors.red;
      case GameCard.green:
        return Colors.green;
      case GameCard.black:
        return Colors.black;
      case GameCard.white:
        return Colors.white;
      default:
        return Colors.blue;
    }
  }
}
