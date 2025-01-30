import 'package:SwordMageRestart/game_internals/stamina.dart';
import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  static const maxCards = 6;
  final Stamina stamina;
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
    required int initialStamina,
    required this.name,
  }) : stamina = Stamina(initialStamina);

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

  void playTurn() {
    // while (stamina.stamina > 0 && hand.isNotEmpty) {
    //   playCard();
    // }
  }
}
