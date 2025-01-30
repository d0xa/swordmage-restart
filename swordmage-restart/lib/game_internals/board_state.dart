// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/monsters.dart';
import 'package:SwordMageRestart/game_internals/playing_card.dart';
import 'package:SwordMageRestart/game_internals/score.dart';
import 'package:SwordMageRestart/play_session/turn_change_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'player.dart';
import 'playing_area.dart';

class BoardState extends ChangeNotifier {
  final VoidCallback onWin;

  final PlayingArea areaOne = PlayingArea();

  final PlayingArea areaTwo = PlayingArea();

  final List<Mob> mobs = Monsters.generateMobs(3);

  // final Player player = Player(health: 100, speed: 10, initialStamina: 50, name: '');

  final Player player = Player(
      name: 'Chacho', health: 6, maxHealth: 6, speed: 10, initialStamina: 4);

  // final List<Mob> mobs = List.generate(
  //     3,
  //     (index) => Mob(
  //         name: 'Goblin ${index + 1}',
  //         health: 3,
  //         speed: 5,
  //         initialStamina: 3,
  //         mobType: 'Goblin'));

  // void _initializeMobs() {
  //   // Example: create initial mobs (do this ONCE)
  //   mobs.add(Mob(
  //       health: 3,
  //       maxHealth: 3,
  //       speed: 1,
  //       initialStamina: 3,
  //       maxStamina: 3,
  //       mobType: "Goblin",
  //       name: "Goblin 1"));
  //   mobs.add(Mob(
  //       health: 4,
  //       maxHealth: 4,
  //       speed: 1,
  //       initialStamina: 4,
  //       maxStamina: 4,
  //       mobType: "Orc",
  //       name: "Orc 1"));
  //   // ... add more mobs
  // }

  List<dynamic> allEntities = [];
  int currentTurnIndex = 0;

  BoardState({required this.onWin}) {
    // _initializeMobs();
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

  @override
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
      // selectedMob = null;
      notifyListeners();
    }
  }

  void applyDamageToPlayer(Player? selectedPlayer, BuildContext context) {
    if (selectedPlayer != null) {
      int totalDamage = areaTwo.cards.fold(0, (sum, card) => sum + card.attack);
      // int totalValues = areaTwo.cards.fold(0, (sum, card) => sum + card.value);
      player.health -= totalDamage;
      areaTwo.clearCards();
      if (player.health <= 0) {
        // Text("You lose");
        GoRouter.of(context).go('/lose');
      }
      // if (mobs.every((mob) => mob.health <= 0)) {
      //   onWin();
      // }
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

  Future<void> endTurn(BuildContext context) async {
    final currentTurnEntity = getCurrentTurnEntity();
    if (currentTurnEntity is Player) {
      _handlePlayerTurnEnd(currentTurnEntity);
    } else if (currentTurnEntity is Mob) {
      await _handleMobTurn(currentTurnEntity, context);
    }
    areaOne.clearCards();
    areaTwo.clearCards();
    currentTurnEntity.isTurn = false;
    currentTurnIndex = (currentTurnIndex + 1) % allEntities.length;
    _setTurnForCurrentEntity();
    notifyListeners();

    // If the next turn is a Mob, handle the Mob's turn immediately
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TurnChangeDialog(color: Colors.purple);
      },
    );

    _setTurnForCurrentEntity();
    notifyListeners();

    // If the next turn is a Mob, handle the Mob's turn immediately
    if (getCurrentTurnEntity() is Mob) {
      await Future.delayed(Duration(seconds: 1)); // Optional delay for realism
      await endTurn(context);
    }
  }

  void _handlePlayerTurnEnd(Player player) {
    player.stamina.increase(2);
    final cardsUsed = Player.maxCards - player.hand.length;
    for (int i = 0; i < cardsUsed; i++) {
      player.drawCard(PlayingCard.random());
    }
    player.isTurn = false;
  }

  Future<void> _handleMobTurn(Mob mob, BuildContext context) async {
    final random = Random();
    while (mob.stamina.stamina > 0 && mob.hand.isNotEmpty) {
      final cardIndex = random.nextInt(mob.hand.length);
      final card = mob.hand[cardIndex];
      final cardValue = random.nextInt(mob.stamina.stamina) + 1;

      if (mob.stamina.stamina >= cardValue) {
        await Future.delayed(Duration(seconds: 1));
        areaTwo.acceptCard(card);
        mob.removeCard(card);
        mob.stamina.decrease(cardValue);
      }
    }
    await Future.delayed(Duration(seconds: 2));
    applyDamageToPlayer(player, context);
    _handleMobTurnEnd(mob);
  }

  void _handleMobTurnEnd(Mob mob) {
    mob.stamina.increase(1);
    final cardsUsed = Mob.maxCards - mob.hand.length;
    mob.drawCard(PlayingCard.random());
    // for (int i = 0; i < cardsUsed; i++) {
    //   mob.drawCard(PlayingCard.random());
    // }
    mob.isTurn = false;
  }

  void _setTurnForCurrentEntity() {
    final currentTurnEntity = getCurrentTurnEntity();
    currentTurnEntity.isTurn = true;
    notifyListeners();
  }

  int? _hoveredCardIndex;

  int? get hoveredCardIndex => _hoveredCardIndex;

  void setHoveredCardIndex(int? index) {
    _hoveredCardIndex = index;
    notifyListeners();
  }
}
