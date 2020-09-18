
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class BundleEmoji extends StatelessWidget {
  final int size;
  final int percent;
  BundleEmoji(this.size, this.percent);
  final bundlemoji = {
    1: {'base': 'low_brightness', 'max': 'high_brightness'},
    3: {'base': 'dizzy', 'max': 'star'},
    4: {'base': 'innocent', 'max': 'fire'},
    10: {'base': 'baby_bottle', 'max': 'baby_bottle'},
    30: {'base': 'popcorn', 'max': 'popcorn'},
    50: {'base': 'bread', 'max': 'bread'},
    150: {'base': 'fries', 'max': 'fries'},
    400: {'base': 'rice', 'max': 'rice'},
    800: {'base': 'pizza', 'max': 'pizza'},
  };

  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    var discount = percent > 64 ? 'max' : 'base';
    return Text(
      parser.emojify(":${bundlemoji[size][discount]}:"),
      style: TextStyle(fontSize: 25.0),
    );
  }
}