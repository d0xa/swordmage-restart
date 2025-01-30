import 'package:SwordMageRestart/play_session/mob_playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/mob.dart';

class MobHandWidget extends StatelessWidget {
  // final Mob mob;

  const MobHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mob = context.watch<Mob>();
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: MobPlayingCardWidget.height,
          maxHeight: MobPlayingCardWidget.height, // Add a max height
        ),
        child: ListenableBuilder(
          listenable: mob,
          builder: (context, child) {
            final hand = mob.hand;
            final cardCount = hand.length;

            return Transform.rotate(
              angle:
                  3.14159, // Rotate the entire widget by 180 degrees (pi radians)
              child: SizedBox(
                height: MobPlayingCardWidget.height * 2, // Ensure finite height
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: hand.asMap().entries.map((entry) {
                    final index = entry.key;
                    final card = entry.value;

                    // Calculate the angle and offset for the fan layout
                    final angle = (index - (cardCount - 1) / 2) *
                        0.1; // Adjust the angle for fan effect
                    final offset =
                        index * 50.0; // Increase the offset for spacing

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      bottom: 0,
                      left: (MediaQuery.of(context).size.width / 2) -
                          (cardCount * 50 / 2) +
                          offset,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: 1.0, // No hover effect for mob cards
                        child: Transform.rotate(
                          angle: angle,
                          alignment: Alignment
                              .bottomCenter, // Rotate around the bottom center
                          child: MobPlayingCardWidget(card, mob: mob),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
