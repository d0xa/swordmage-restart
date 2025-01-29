import 'package:SwordMageRestart/game_internals/stamina.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
// import '../game_internals/card_suit.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';

class PlayingCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double width = 100;
  static const double height = 110;

  final PlayingCard card;

  final Player? player;

  const PlayingCardWidget(this.card, {this.player, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textColor = palette.ink;
    // card.suit.color == CardSuitColor.red ? palette.redPen : palette.ink;

    // final cardWidget = DefaultTextStyle(
    //   style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
    //   child: Container(
    //     width: width,
    //     height: height,
    //     decoration: BoxDecoration(
    //       color: palette.trueWhite,
    //       border: Border.all(color: palette.ink),
    //       borderRadius: BorderRadius.circular(5),
    //     ),
    //     child: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Flexible(
    //             flex: 10,
    //             child: Image.asset(card.imagePath),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    final cardWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(color: palette.ink),
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage(card.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    /// Cards that aren't in a player's hand are not draggable.
    if (player == null) return cardWidget;

    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: cardWidget,
      ),
      data: PlayingCardDragData(card, player!),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: cardWidget,
      ),
      onDragStarted: () {
        final stamina = context.read<Stamina>();
        if (stamina.stamina < card.value) {
          // Prevent dragging if stamina is insufficient
          return;
        }
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.huhsh);
      },
      onDragEnd: (details) {
        final stamina = context.read<Stamina>();
        if (stamina.stamina >= card.value) {
          // Deduct stamina and complete the drag
          final audioController = context.read<AudioController>();
          audioController.playSfx(SfxType.wssh);
          // stamina.decrease(card.value);
          print(card.value);
        } else {
          // If stamina is insufficient, snap the card back to its original position
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Not enough stamina to play this card!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      onDraggableCanceled: (velocity, offset) {
        // Handle snapping back the card if the drag is canceled
        final stamina = context.read<Stamina>();
        if (stamina.stamina < card.value) {
          // Play a sound or show a message indicating insufficient stamina
          final audioController = context.read<AudioController>();
          audioController.playSfx(SfxType.huhsh);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Not enough stamina to play this card!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
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
