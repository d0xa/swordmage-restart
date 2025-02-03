// import 'dart:ui';
import 'package:SwordMageRestart/game_internals/board_state.dart';
import 'package:SwordMageRestart/game_internals/playScreen/game_components/playing_area_component.dart';
import 'package:SwordMageRestart/game_internals/playScreen/game_components/position_utils.dart';
import 'package:SwordMageRestart/game_internals/playScreen/mobs/goblin/mob_component.dart';
import 'package:SwordMageRestart/game_internals/playScreen/sprite_mob.dart';
// import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';
// import 'package:flutter/material.dart';

class PlayerHandComponent extends PositionComponent with DragCallbacks {
  final BoardState boardState;
  static const double cardWidth = 50;
  static const double cardHeight = 70;

  int? selectedCardIndex;
  int? hoveredCardIndex;

  late final Map<String, Sprite> cardSprites;
  late final List<Vector2> originalPositions;

  PlayerHandComponent({
    required this.boardState,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(400, cardHeight * 2),
        );

  @override
  Future<void> onLoad() async {
    cardSprites = {
      'slash': await Sprite.load('cards/Slash-1.png'),
      // 'block': await gameRef.loadSprite('cards/block.png'),
      // Add other card sprites
    };
    // print(cardSprites);
    final List<String> cardNames = [
      'slash',
      // 'block',
      // 'another_card'
    ]; // Example card names
    originalPositions = []; // Init

    double x = 0;
    for (int i = 0; i < 5; i++) {
      final sprite = cardSprites["slash"];
      if (sprite != null) {
        final cardComponent = SpriteComponent(
          sprite: sprite,
          size: Vector2(cardWidth, cardHeight),
          position: Vector2(x, 0), // Adjust y for overlap if needed
        );
        add(cardComponent);
        originalPositions.add(Vector2(x, 0));
        // print(originalPositions);
        x += cardWidth + 10; // Add spacing between cards
      } else {
        // print('Error: Sprite not found for $cardName');
      }
    }
  }

  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final localPosition = event.localPosition;
    // print(localPosition);
    hoveredCardIndex = _getCardIndexAtPosition(localPosition);
    if (hoveredCardIndex != null) {
      selectedCardIndex = hoveredCardIndex;
      return true;
    }
    return false;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (selectedCardIndex != null) {
      final cardComponent =
          children.elementAt(selectedCardIndex!) as SpriteComponent;
      cardComponent.position += event.localDelta;
    }
  }

  // @override
  // void onDragEnd(DragEndEvent event) {
  //   super.onDragEnd(event);
  //   if (selectedCardIndex != null) {
  //     final cardComponent =
  //         children.elementAt(selectedCardIndex!) as SpriteComponent;
  //     final originalPosition = originalPositions[selectedCardIndex!];
  //     cardComponent.position = originalPosition; // Return to original position
  //     selectedCardIndex = null;
  //   }
  // }
  // @override
  // void onDragEnd(DragEndEvent event) {
  //   super.onDragEnd(event);
  //   if (selectedCardIndex != null) {
  //     final cardComponent =
  //         children.elementAt(selectedCardIndex!) as SpriteComponent;
  //     final originalPosition = originalPositions[selectedCardIndex!];

  //     // Check if card is dropped in a valid playing area
  //     final playingAreas = parent!.children.whereType<PlayingAreaComponent>();
  //     bool cardAccepted = false;
  //     for (final area in playingAreas) {
  //       if (area.toRect().contains(cardComponent.position.toOffset())) {
  //         // area.acceptCard(PlayingCard(type: 'slash')); // Example card type
  //         area.acceptCard(cardComponent);
  //         cardAccepted = true;
  //         break;
  //       }
  //     }

  //     if (cardAccepted) {
  //       // Remove card from hand
  //       remove(cardComponent);
  //       originalPositions.removeAt(selectedCardIndex!);
  //     } else {
  //       // Return to original position
  //       cardComponent.position = originalPosition;
  //     }

  //     selectedCardIndex = null;
  //   }
  // }
  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    // Ensure this method is called in the correct context
    if (selectedCardIndex == null) return;

    final cardComponent =
        children.elementAt(selectedCardIndex!) as SpriteComponent;

    // Convert card position to world space
    final cardWorldPosition =
        PositionUtils.localToGlobal(cardComponent.position, this);
    // print('Card World Position: $cardWorldPosition');

    final mobs = parent!.children.whereType<MobSprite>();
    // print("mobs $mobs");
    for (final mob in mobs) {
      final playingArea = mob.children.whereType<PlayingAreaComponent>().first;
      // print('PlayingArea: $playingArea');

      if (playingArea.parent is PositionComponent) {
        final areaWorldPosition = PositionUtils.localToGlobal(
            playingArea.position, playingArea.parent! as PositionComponent);
        final areaWorldRect = Rect.fromLTWH(areaWorldPosition.x,
            areaWorldPosition.y, playingArea.size.x, playingArea.size.y);

        // print('PlayingArea World Position: $areaWorldPosition');
        // print('PlayingArea World Rect: $areaWorldRect');

        if (areaWorldRect.contains(cardWorldPosition.toOffset())) {
          // print('Card accepted!');
          remove(cardComponent);
          playingArea.acceptCard(cardComponent);
          originalPositions.removeAt(selectedCardIndex!);
          selectedCardIndex = null;
          return; // Exit the loop after accepting the card
        }
      }
    }

    // Reset card position if not accepted
    cardComponent.position = originalPositions[selectedCardIndex!];
    selectedCardIndex = null;
  }

  int? _getCardIndexAtPosition(Vector2 position) {
    for (int i = 0; i < children.length; i++) {
      final cardComponent =
          children.elementAt(i) as SpriteComponent; // More concise
      final cardRect =
          cardComponent.toRect(); // Use the *component's* rectangle!
      if (cardRect.contains(position.toOffset())) {
        return i;
      }
    }
    return null;
  }

  // @override
  // void render(Canvas canvas) {
  //   final hand = boardState.player.hand;
  //   final cardCount = hand.length;
  //   // print('Rendering ${hand.length} cards');

  //   for (var i = 0; i < cardCount; i++) {
  //     final card = hand[i];
  //     final angle = (i - (cardCount - 1) / 2) * 0.05;
  //     final offset = i * cardWidth * 0.98;

  //     canvas.save();
  //     canvas.translate(offset, 0);
  //     canvas.rotate(angle);

  //     final sprite = cardSprites["slash"];
  //     // if (sprite != null) {

  //     if (sprite != null) {
  //       // print('Rendering sprite for card: ${card}');
  //       sprite.render(
  //         canvas,
  //         size: Vector2(cardWidth, cardHeight),
  //       );
  //     } else {
  //       print('couldnt render ${card}');
  //       canvas.drawRect(
  //         Rect.fromLTWH(0, 0, cardWidth, cardHeight),
  //         Paint()..color = Colors.orange,
  //       );
  //     }

  //     canvas.restore();
  //   }
  // }
}
// }
