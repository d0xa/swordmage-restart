import 'package:SwordMageRestart/game_internals/board_state.dart';
import 'package:SwordMageRestart/game_internals/playing_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/mob.dart';
import '../game_internals/player.dart';

class EndTurnButton extends StatelessWidget {
  const EndTurnButton({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<Player>();
    final mobs = context.watch<List<Mob>>();
    final allEntities = [player, ...mobs];
    final selectedMobNotifier = context.read<ValueNotifier<Mob?>>();

    allEntities.sort((a, b) {
      final aSpeed = a is Player ? a.speed : (a as Mob).speed;
      final bSpeed = b is Player ? b.speed : (b as Mob).speed;
      return bSpeed.compareTo(aSpeed);
    });
    final currentTurnEntity = allEntities.first;

    return ElevatedButton(
      onPressed: () {
        // Assuming you have a BoardState provider
        final boardState = context.read<BoardState>();
        selectedMobNotifier.value = null;
        boardState.endTurn();
      },
      child: Text('End Turn'),
    );
    // return ElevatedButton(
    //   onPressed: () {
    //     if (currentTurnEntity is Player) {
    //       // Player's turn logic
    //       // Implement player turn logic here
    //       (currentTurnEntity).isTurn = true;
    //       _handlePlayerTurnEnd(currentTurnEntity);
    //     } else if (currentTurnEntity is Mob) {
    //       // Mob's turn logic
    //       // Implement mob turn logic here
    //     }
    //     // Switch turn to the next entity
    //     (currentTurnEntity as Mob).isTurn = true;
    //     (currentTurnEntity).playTurn();
    //     _handleMobTurnEnd(mobs);
    //     allEntities.add(allEntities.removeAt(0));
    //     selectedMobNotifier.value = null; //Deselect mob

    //     // Update turn logic
    //   },
    //   child: Text('End Turn'),
    // );
  }

  void _handlePlayerTurnEnd(Player player) {
    // Restore stamina by 2 points
    player.stamina.increase(2);

    // Draw cards equal to the ones used
    final cardsUsed = Player.maxCards - player.hand.length;
    for (int i = 0; i < cardsUsed; i++) {
      player.drawCard(PlayingCard.random());
    }
    player.isTurn = false;
  }

  void _handleMobTurnEnd(List<Mob> mobs) {
    for (var mob in mobs) {
      // Give a brand new hand to each mob
      mob.stamina.increase(2);
      mob.hand.clear();
      for (int i = 0; i < Player.maxCards; i++) {
        mob.drawCard(PlayingCard.random());
      }
      mob.isTurn = false;
    }
  }
}
