import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/mob.dart';
import 'playing_card_widget.dart';

class MobHandWidget extends StatelessWidget {
  final Mob mob;

  const MobHandWidget({super.key, required this.mob});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: PlayingCardWidget.height),
        child: ListenableBuilder(
          listenable: mob,
          builder: (context, child) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ...mob.hand.take(4).map((card) => PlayingCardWidget(card)),
              ],
            );
          },
        ),
      ),
    );
  }
}
