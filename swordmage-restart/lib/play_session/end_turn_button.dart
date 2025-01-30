import 'package:SwordMageRestart/game_internals/board_state.dart';
import 'package:SwordMageRestart/game_internals/playing_card.dart';
import 'package:SwordMageRestart/play_session/turn_change_dialog.dart';
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
      onPressed: () async {
        // Assuming you have a BoardState provider
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const TurnChangeDialog(color: Colors.orange);
          },
        );
        final boardState = context.read<BoardState>();
        selectedMobNotifier.value = null;
        boardState.endTurn(context);
      },
      child: Text('End Turn'),
    );
  }
}
