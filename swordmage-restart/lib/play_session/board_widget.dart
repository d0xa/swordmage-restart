import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
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
    // final player = context.watch<Player>();
    // final mobs = context.watch<List<Mob>>();
    // final selectedMobNotifier = context.read<ValueNotifier<Mob?>>();

    return Row(
      children: [
        Expanded(
          child: PlayingAreaWidget(
            area: boardState.areaOne,
            isPlayerArea: true,
            isMobArea: false,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: PlayingAreaWidget(
            area: boardState.areaTwo,
            isPlayerArea: false,
            isMobArea: true,
          ),
        ),
      ],
    );
  }
}
