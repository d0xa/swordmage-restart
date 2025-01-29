import 'package:SwordMageRestart/game_internals/custom_tool_tip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  const PlayerHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: PlayingCardWidget.height,
          // maxHeight: PlayingCardWidget.height * 2, // Add a max height
        ),
        child: ListenableBuilder(
          listenable: boardState.player,
          builder: (context, child) {
            final hand = boardState.player.hand;
            final cardCount = hand.length;
            final screenWidth = MediaQuery.of(context).size.width;

            // Calculate the maximum width available for each card
            // final maxCardWidth = (screenWidth - 20) / cardCount;
            final maxCardWidth = (screenWidth - 25) / cardCount;
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
                  final offset = index *
                      maxCardWidth *
                      .98; // Adjust the offset for spacing

                  return Positioned(
                    bottom: 0,
                    left: offset,
                    child: GestureDetector(
                      // onTap: () => _onHover(context, index, true),
                      onLongPress: () => _onHover(context, index, true),
                      child: Transform.rotate(
                        angle: angle,
                        alignment: Alignment
                            .bottomCenter, // Rotate around the bottom center
                        child: CustomTooltip(
                          message: card.description,
                          child: SizedBox(
                            height: PlayingCardWidget.height * 1.2,
                            width: cardWidth,
                            child: PlayingCardWidget(card,
                                player: boardState.player),
                          ),
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
}
