import 'package:SwordMageRestart/game_internals/retro_circle.dart';
import 'package:SwordMageRestart/game_internals/stamina.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import '../game_internals/playing_card_drag_data.dart';
import '../style/palette.dart';

class PlayingCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double width = 100;
  static const double height = 110;

  final PlayingCard card;
  final Player? player;
  final bool isGhost;

  const PlayingCardWidget(this.card,
      {this.player, this.isGhost = false, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textColor = palette.ink;

    final cardWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
      child: Container(
        width: isGhost ? width * 1.5 : width,
        height: isGhost ? height * 1.5 : height,
        decoration: BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(color: palette.ink),
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage(card.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none, // Allow overflow
          children: [
            Positioned(
              bottom: -10, // Position slightly outside the card
              left: -10, // Position slightly outside the card
              child: EightBitCircle(
                value: card.attack,
                color: Colors.orange,
              ),
            ),
            Positioned(
              bottom: -10, // Position slightly outside the card
              right: -10, // Position slightly outside the card
              child: EightBitCircle(
                value: card.value,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );

    /// Cards that aren't in a player's hand are not draggable.
    if (player == null || isGhost) return cardWidget;

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
        print('Drag ended for player card: ${details}');
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
