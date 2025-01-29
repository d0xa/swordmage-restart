import 'dart:math';

import 'package:flutter/foundation.dart';

@immutable
class PlayingCard {
  static final _random = Random();

  // final CardSuit suit; // Commented out as requested
  final int value;
  final int attack;
  final String imagePath;
  final String description;

  const PlayingCard(this.attack, this.value, this.imagePath, this.description);

  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    return PlayingCard(
      // CardSuit.values.singleWhere((e) => e.internalRepresentation == json['suit']),
      json['value'] as int,
      json['attack'] as int,
      json['imagePath'] as String,
      json['description'] as String,
    );
  }

  factory PlayingCard.random([Random? random]) {
    // random ??= _random;
    return PlayingCard(
      // CardSuit.hearts,
      1,
      1,
      'assets/images/cards/Slash-1.png',
      'Deal 1 Slash damage',
    );
  }

  @override
  int get hashCode => Object.hash(/*suit,*/ value, imagePath);

  @override
  bool operator ==(Object other) {
    return other is PlayingCard &&
        // other.suit == suit &&
        other.value == value &&
        other.imagePath == imagePath;
  }

  Map<String, dynamic> toJson() => {
        // 'suit': suit.internalRepresentation,
        'value': value,
        'imagePath': imagePath,
      };

  @override
  String toString() {
    return '$value';
  }
}
