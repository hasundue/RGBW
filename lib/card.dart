import 'package:flutter/material.dart';

class ColoredCard extends SizedBox {
  ColoredCard({Key? key, color})
  : super(
    key: key,
    child: Card(
      color: color,
      elevation: 10),
    width: 60,
    height: 80,
  );
}

class PlayerCard extends ColoredCard {
  PlayerCard({Key? key, color})
  : super(
      key: key,
      color: color,
  );
}
