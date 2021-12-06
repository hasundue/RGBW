import 'package:flutter/material.dart';

class ColoredCard extends SizedBox {
  ColoredCard({Key? key, color}) : super(
    key: key,
    child: Card(color: color, elevation: 10),
    width: 60,
    height: 80,
  );
}
