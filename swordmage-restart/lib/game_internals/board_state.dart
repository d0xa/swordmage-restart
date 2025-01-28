// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/playing_card.dart';
import 'package:flutter/foundation.dart';

import 'player.dart';
import 'playing_area.dart';

class BoardState extends ChangeNotifier {
  final VoidCallback onWin;

  final PlayingArea areaOne = PlayingArea();

  final PlayingArea areaTwo = PlayingArea();

  // final Player player = Player(health: 100, speed: 10, initialStamina: 50, name: '');

  final Player player =
      Player(name: 'Chacho', health: 10, speed: 10, initialStamina: 10);

  final List<Mob> mobs = List.generate(
      3,
      (index) => Mob(
          name: 'Goblin ${index + 1}',
          health: 3,
          speed: 5,
          initialStamina: 10,
          mobType: 'Goblin'));

  List<dynamic> allEntities = [];
  int currentTurnIndex = 0;

  BoardState({required this.onWin}) {
    player.addListener(_handlePlayerChange);
    allEntities = [player, ...mobs];
    // allEntities.sort((a, b) => b.speed.compareTo(a.speed));
    allEntities.sort((a, b) {
      final aSpeed = a is Player ? a.speed : (a as Mob).speed;
      final bSpeed = b is Player ? b.speed : (b as Mob).speed;
      return bSpeed.compareTo(aSpeed);
    });
    _setTurnForCurrentEntity();
  }

  List<PlayingArea> get areas => [areaOne, areaTwo];

  void dispose() {
    player.removeListener(_handlePlayerChange);
    areaOne.dispose();
    areaTwo.dispose();
  }

  void applyDamageToSelectedMob(Mob? selectedMob) {
    if (selectedMob != null) {
      int totalDamage = areaOne.cards.fold(0, (sum, card) => sum + card.attack);
      selectedMob.health -= totalDamage;
      areaOne.clearCards();
      if (selectedMob.health <= 0) {
        allEntities.remove(selectedMob);
      }
      if (mobs.every((mob) => mob.health <= 0)) {
        onWin();
      }
      notifyListeners();
    }
  }

  void _handlePlayerChange() {
    // if (player.hand.isEmpty) {
    //   onWin();
    // }
  }

  dynamic getCurrentTurnEntity() {
    return allEntities[currentTurnIndex];
  }

  void endTurn() {
    final currentTurnEntity = getCurrentTurnEntity();
    if (currentTurnEntity is Player) {
      _handlePlayerTurnEnd(currentTurnEntity);
      // print('Player turn ended');
    } else if (currentTurnEntity is Mob) {
      currentTurnEntity.playTurn();
      // print('Mob turn ended');
    }
    currentTurnEntity.isTurn = false;
    currentTurnIndex = (currentTurnIndex + 1) % allEntities.length;
    _setTurnForCurrentEntity();
    notifyListeners();
  }

  void _handlePlayerTurnEnd(Player player) {
    player.stamina.increase(2);
    final cardsUsed = Player.maxCards - player.hand.length;
    for (int i = 0; i < cardsUsed; i++) {
      player.drawCard(PlayingCard.random());
    }
    player.isTurn = false;
  }

  void _handleMobTurnEnd(List<Mob> mobs) {
    for (var mob in mobs) {
      mob.stamina.increase(2);
      mob.hand.clear();
      for (int i = 0; i < Player.maxCards; i++) {
        mob.drawCard(PlayingCard.random());
      }
      mob.isTurn = false;
    }
  }

  void _setTurnForCurrentEntity() {
    final currentTurnEntity = getCurrentTurnEntity();
    currentTurnEntity.isTurn = true;
  }
}
