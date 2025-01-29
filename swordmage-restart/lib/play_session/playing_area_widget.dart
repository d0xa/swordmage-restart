import 'dart:math';

import 'package:SwordMageRestart/game_internals/board_state.dart';
import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:SwordMageRestart/game_internals/stamina.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/playing_area.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';
import 'playing_card_widget.dart';

class PlayingAreaWidget extends StatefulWidget {
  final PlayingArea area;
  final bool isPlayerArea;
  final bool isMobArea;

  const PlayingAreaWidget({
    super.key,
    required this.area,
    required this.isPlayerArea,
    required this.isMobArea,
  });

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final boardState = context.watch<BoardState>();
    final player = boardState.player;
    // final mob = context.watch<Mob>();

    return DragTarget<PlayingCardDragData>(
      onWillAcceptWithDetails: (details) {
        if (widget.isPlayerArea) {
          print(details.data.holder);
          return player.isTurn && details.data.holder is Player;
        }
        if (widget.isMobArea) {
          print(details.data.holder);
          return !player.isTurn && details.data.holder is Mob;
        }
        return false;
      },
      onAcceptWithDetails: (details) => _onDragAccept(details),
      onLeave: (data) => _onDragLeave(data),
      builder: (context, candidateData, rejectedData) => Container(
        color: isHighlighted ? palette.accept : palette.trueWhite,
        child: InkWell(
          splashColor: palette.redPen,
          onTap: _onAreaTap,
          child: StreamBuilder(
            stream: widget.area.allChanges,
            builder: (context, snapshot) => _CardStack(widget.area.cards),
          ),
        ),
      ),
    );
  }

  void _onAreaTap() {
    widget.area.removeFirstCard();

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.huhsh);
  }

  void _onDragAccept(DragTargetDetails<PlayingCardDragData> details) {
    print(details);
    final stamina = context.read<Stamina>();
    
    if (stamina.stamina >= details.data.card.value) {
      widget.area.acceptCard(details.data.card);
      details.data.holder.removeCard(details.data.card);
      stamina.decrease(details.data.card.value);
    } else {
      // If stamina is insufficient, snap the card back to its original position
      final audioController = context.read<AudioController>();
      audioController.playSfx(SfxType.huhsh);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough stamina to play this card!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    setState(() => isHighlighted = false);
  }

  void _onDragLeave(PlayingCardDragData? data) {
    setState(() => isHighlighted = false);
  }

  bool _onDragWillAccept(DragTargetDetails<PlayingCardDragData> details) {
    setState(() => isHighlighted = true);
    return true;
  }
}

class _CardStack extends StatelessWidget {
  static const int _maxCards = 6;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  static const double _maxWidth =
      _maxCards * _leftOffset + PlayingCardWidget.width;

  static const _maxHeight = _maxCards * _topOffset + PlayingCardWidget.height;

  final List<PlayingCard> cards;

  const _CardStack(this.cards);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, cards.length - _maxCards);
                i < cards.length;
                i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingCardWidget(cards[i]),
              ),
          ],
        ),
      ),
    );
  }
}
