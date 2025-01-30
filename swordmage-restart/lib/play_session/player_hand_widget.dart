import 'dart:async';

import 'package:SwordMageRestart/game_internals/custom_tool_tip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatefulWidget {
  PlayerHandWidget({super.key});

  @override
  _PlayerHandWidgetState createState() => _PlayerHandWidgetState();
}

class _PlayerHandWidgetState extends State<PlayerHandWidget> {
  int? _selectedCardIndex;
  Timer? _ghostCardTimer;

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: PlayingCardWidget.height,
        ),
        child: ListenableBuilder(
          listenable: boardState.player,
          builder: (context, child) {
            final hand = boardState.player.hand;
            final cardCount = hand.length;
            final screenWidth = MediaQuery.of(context).size.width;

            // Calculate the maximum width available for each card
            final maxCardWidth = (screenWidth - 20) / cardCount;
            final cardWidth =
                cardCount <= 3 ? PlayingCardWidget.width : maxCardWidth;

            return SizedBox(
              height: PlayingCardWidget.height * 2, // Ensure finite height
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: hand.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = entry.value;

                  // Calculate the angle and offset for the fan layout
                  final angle = (index - (cardCount - 1) / 2) *
                      0.05; // Adjust the angle for fan effect
                  final offset =
                      index * cardWidth * 0.98; // Adjust the offset for spacing

                  return Positioned(
                    bottom: 0,
                    left: offset,
                    child: GestureDetector(
                      onLongPress: () =>
                          _showGhostCard(context, index, boardState),
                      // onLongPressEnd: (_) => _hideGhostCard(),
                      child: Transform.rotate(
                        angle: angle,
                        alignment: Alignment
                            .bottomCenter, // Rotate around the bottom center
                        child: SizedBox(
                          height: PlayingCardWidget.height,
                          width: cardWidth,
                          child: PlayingCardWidget(card,
                              player: boardState.player),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onHover(BuildContext context, int index, bool isHovered) {
    final boardState = context.read<BoardState>();
    boardState.setHoveredCardIndex(isHovered ? index : null);
  }

  void _showGhostCard(BuildContext context, int index, BoardState boardState) {
    setState(() {
      _selectedCardIndex = index;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        final card = boardState.player.hand[_selectedCardIndex!];

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: PlayingCardWidget(card,
                player: boardState.player, isGhost: true),
          ),
        );
      },
    );

    _ghostCardTimer?.cancel(); // Cancel any existing timer
    _ghostCardTimer = Timer(Duration(seconds: 2), () {
      _hideGhostCard();
    });
  }

  void _hideGhostCard() {
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _selectedCardIndex = null;
    });
  }
}
