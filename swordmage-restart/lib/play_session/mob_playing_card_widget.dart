import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/stamina.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
// import '../game_internals/card_suit.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';

class MobPlayingCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  // static const double width = 57.1;
  static const double width = 90;
  static const double height = 130;
  // static const double height = 88.9;

  final PlayingCard card;

  final Mob? mob;

  const MobPlayingCardWidget(this.card, {this.mob, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textColor = palette.ink;
    // card.suit.color == CardSuitColor.red ? palette.redPen : palette.ink;

    final cardWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(color: palette.ink),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(card.imagePath
                  // , width: 40, height: 40
                  ),
              // Text('${card.value}', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );

    /// Cards that aren't in a player's hand are not draggable.
    if (mob == null) return cardWidget;

    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: cardWidget,
      ),
      data: PlayingCardDragData(card, mob!),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: cardWidget,
      ),
      onDragStarted: () {
        // Commented out stamina check
        // final stamina = context.read<Stamina>();
        // if (stamina.stamina < card.value) {
        //   // Prevent dragging if stamina is insufficient
        //   return;
        // }
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.huhsh);
      },
      onDragEnd: (details) {
        // Commented out stamina check
        // final stamina = context.read<Stamina>();
        // if (stamina.stamina >= card.value) {
        //   // Deduct stamina and complete the drag
        //   final audioController = context.read<AudioController>();
        //   audioController.playSfx(SfxType.wssh);
        //   // stamina.decrease(card.value);
        //   // print(card.value);
        // } else {
        //   // If stamina is insufficient, snap the card back to its original position
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Not enough stamina to play this card!'),
        //       duration: Duration(seconds: 1),
        //     ),
        //   );
        // }
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.wssh);
      },
      onDraggableCanceled: (velocity, offset) {
        // Commented out stamina check
        // Handle snapping back the card if the drag is canceled
        // final stamina = context.read<Stamina>();
        // if (stamina.stamina < card.value) {
        //   // Play a sound or show a message indicating insufficient stamina
        //   final audioController = context.read<AudioController>();
        //   audioController.playSfx(SfxType.huhsh);
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Not enough stamina to play this card!'),
        //       duration: Duration(seconds: 1),
        //     ),
        //   );
        // }
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.huhsh);
      },
      child: cardWidget,
    );
  }
}

@immutable
class PlayingCardDragData {
  final PlayingCard card;

  final dynamic holder;

  const PlayingCardDragData(this.card, this.holder);
}
