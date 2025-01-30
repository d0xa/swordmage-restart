import 'package:SwordMageRestart/game_internals/stamina.dart';
import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  static const maxCards = 6;
  // final Stamina stamina;
  int stamina;
  int maxStamina;
  final int speed;
  int health;
  int maxHealth;
  bool isTurn = false;
  String name;
  // late List<PlayingCard> hand;
  // final List<PlayingCard> hand = [];
  Player({
    required this.health,
    required this.maxHealth,
    required this.speed,
    required this.stamina,
    required this.maxStamina,
    required this.name,
  });

  final List<PlayingCard> hand =
      List.generate(maxCards, (index) => PlayingCard.random());

  void drawCard(PlayingCard card) {
    hand.add(card);
    notifyListeners();
  }

  void removeCard(PlayingCard card) {
    hand.remove(card);
    notifyListeners();
  }

  void increaseMaxHealth() {
    maxHealth += 1;
    notifyListeners();
  }

  void increaseMaxStamina() {
    maxStamina += 1;
    notifyListeners();
  }

  void resetStamina() {
    stamina = maxStamina;
    notifyListeners();
  }

  void increaseStamina(int amount) {
    stamina += amount;
    notifyListeners();
  }

  void decreaseStamina(int amount) {
    stamina -= amount;
    notifyListeners();
  }
}
