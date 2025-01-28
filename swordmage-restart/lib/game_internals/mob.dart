import 'dart:math';

import 'package:flutter/foundation.dart';

import 'playing_card.dart';
import 'stamina.dart';

class Mob extends ChangeNotifier {
  final List<PlayingCard> hand = [];
  final Stamina stamina;
  final int speed;
  int health;
  final String mobType;
  bool isTurn = false;
  String name;

  Mob({
    required this.health,
    required this.speed,
    required int initialStamina,
    required this.mobType,
    required this.name,
    // this.isTurn = false,
  }) : stamina = Stamina(initialStamina);

  void drawCard(PlayingCard card) {
    hand.add(card);
    notifyListeners();
  }

  void playCard() {
    if (hand.isEmpty || stamina.stamina <= 0) return;

    final random = Random();
    final cardIndex = random.nextInt(hand.length);
    final card = hand.removeAt(cardIndex);

    if (stamina.stamina >= card.value) {
      stamina.decrease(card.value);
      // Implement card effect logic here
      notifyListeners();
    } else {
      hand.add(card); // Return the card to the hand if not enough stamina
    }
  }

  void playTurn() {
    while (stamina.stamina > 0 && hand.isNotEmpty) {
      playCard();
    }
  }
}
