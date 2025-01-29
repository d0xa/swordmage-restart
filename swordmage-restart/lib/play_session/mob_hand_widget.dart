import 'package:SwordMageRestart/play_session/mob_playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/mob.dart';
import 'playing_card_widget.dart';

class MobHandWidget extends StatelessWidget {
  // final Mob mob;

  const MobHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mob = context.watch<Mob>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(minHeight: MobPlayingCardWidget.height),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            ...mob.hand.map((card) => MobPlayingCardWidget(card, mob: mob)),
          ],
        ),
      ),
    );
  }
}
