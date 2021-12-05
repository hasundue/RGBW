import 'package:flutter/material.dart';

class ColoredCard extends SizedBox {
  ColoredCard({Color color = Colors.red})
  : super(
    child: Card(
      color: color,
      elevation: 10),
    width: 60,
    height: 80,
  );
}
