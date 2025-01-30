import 'dart:math';

import 'package:SwordMageRestart/game_internals/mob_stamina.dart';
import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Mob extends ChangeNotifier {
  static const maxCards = 4;
  // final List<PlayingCard> hand = [];
  final MobStamina stamina;
  final int maxStamina;
  final int speed;
  int health;
  int maxHealth;
  final String mobType;
  bool isTurn = false;
  String name;

  Mob({
    required this.health,
    required this.speed,
    required int initialStamina,
    required this.mobType,
    required this.name,
    required this.maxHealth,
    required this.maxStamina,
    // this.isTurn = false,
  }) : stamina = MobStamina(initialStamina) {
    stamina.addListener(_onStaminaChanged);
  }
  final List<PlayingCard> _hand =
      List.generate(maxCards, (index) => PlayingCard.random());

  List<PlayingCard> get hand => _hand;

  void drawCard(PlayingCard card) {
    hand.add(card);
    notifyListeners();
  }

  void removeCard(PlayingCard card) {
    hand.remove(card);
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

  void _onStaminaChanged() {
    notifyListeners();
  }
}
