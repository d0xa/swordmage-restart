// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:SwordMageRestart/game_internals/health_bar.dart';
import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'player_hand_widget.dart';
import 'playing_area_widget.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();
    final player = context.watch<Player>();
    final mobs = context.watch<List<Mob>>();
    final selectedMobNotifier = context.read<ValueNotifier<Mob?>>();

    return Row(
      children: [
        Expanded(
          child: PlayingAreaWidget(
            area: boardState.areaOne,
            isPlayerArea: true,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: PlayingAreaWidget(
            area: boardState.areaTwo,
            isPlayerArea: false,
          ),
        ),
      ],
    );
    // return Column(
    //   children: [
    //     Expanded(
    //       child: Row(
    //         children: [
    //           Expanded(
    //             child: Column(
    //               children: [
    //                 Expanded(
    //                   // Maximize the playing area
    //                   child: PlayingAreaWidget(
    //                     area: boardState.areaOne,
    //                     isPlayerArea: true,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 10), // Spacing
    //                 Flexible(
    //                   // Allow health bar to take only the space it needs
    //                   child: HealthBar(
    //                     name: player.isTurn ? "*${player.name}" : player.name,
    //                     health: player.health,
    //                     maxHealth: 10,
    //                     color: Colors.green,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(width: 20), // Spacing between columns
    //           Expanded(
    //             child: Column(
    //               children: [
    //                 Expanded(
    //                   // Maximize the playing area
    //                   child: PlayingAreaWidget(
    //                     area: boardState.areaTwo,
    //                     isPlayerArea: false,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 10), // Spacing
    //                 // Flexible(
    //                 // Allow health bars to take only the space they need
    //                 // child:
    //                 Column(
    //                   children: mobs.asMap().entries.map((entry) {
    //                     int index = entry.key;
    //                     Mob mob = entry.value;
    //                     return ValueListenableBuilder<Mob?>(
    //                       valueListenable: selectedMobNotifier,
    //                       builder: (context, selectedMob, child) {
    //                         return GestureDetector(
    //                           onTap: () {
    //                             if (player.isTurn) {
    //                               selectedMobNotifier.value =
    //                                   selectedMob == mob ? null : mob;
    //                               if (selectedMobNotifier.value != null) {
    //                                 boardState.applyDamageToSelectedMob(
    //                                     selectedMobNotifier.value);
    //                               }
    //                             }
    //                           },
    //                           child: AnimatedContainer(
    //                             duration: Duration(milliseconds: 300),
    //                             child: HealthBar(
    //                               name: mob.isTurn
    //                                   ? "*${mob.name} ${index + 1}"
    //                                   : "${mob.name} ${index + 1}",
    //                               health: mob.health,
    //                               maxHealth: 3,
    //                               color: selectedMob == mob
    //                                   ? Colors.green
    //                                   : Colors.red,
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     );
    //                   }).toList(),
    //                 ),
    //                 // ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     const SizedBox(height: 20), // Spacing
    //     SizedBox(
    //       height: 150, // Fixed height for the player hand
    //       child: const PlayerHandWidget(),
    //     ),
    //   ],
    // );
  }
}
