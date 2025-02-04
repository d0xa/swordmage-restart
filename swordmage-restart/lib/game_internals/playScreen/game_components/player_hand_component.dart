// import 'dart:ui';
import 'package:SwordMageRestart/game_internals/board_state.dart';
import 'package:SwordMageRestart/game_internals/playScreen/flame_game.dart';
// import 'package:flame/input.dart'; // Import this package for DragCallbacks
// import 'package:SwordMageRestart/game_internals/playScreen/game_components/playing_area_component.dart';
// import 'package:SwordMageRestart/game_internals/playScreen/game_components/position_utils.dart';
// import 'package:SwordMageRestart/game_internals/playScreen/mobs/goblin/mob_component.dart';
// import 'package:SwordMageRestart/game_internals/playScreen/sprite_mob.dart';
// // import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
    // required Vector2 position,
  }) : super(
          // position: position,
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
    // print(originalPositions);
  }

  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final localPosition = event.localPosition;
    selectedCardIndex = _getCardIndexAtPosition(localPosition);

    if (selectedCardIndex != null) {
      (findGame() as SwordMageGame).onDragStart(event);
      return true; // Indicate you've handled the start
    }
    return false;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (selectedCardIndex != null) {
      (findGame() as SwordMageGame).onDragUpdate(event);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (selectedCardIndex != null) {
      (findGame() as SwordMageGame).onDragEnd(event);
      selectedCardIndex = null;
    }
  }

  // @override
  // bool onDragStart(DragStartEvent event) {
  //   super.onDragStart(event);
  //   final localPosition = event.localPosition;
  //   // print(localPosition);
  //   hoveredCardIndex = _getCardIndexAtPosition(localPosition);
  //   if (hoveredCardIndex != null) {
  //     selectedCardIndex = hoveredCardIndex;
  //     return true;
  //   }
  //   return false;
  // }

  // @override
  // void onDragUpdate(DragUpdateEvent event) {
  //   super.onDragUpdate(event);
  //   if (selectedCardIndex != null) {
  //     final cardComponent =
  //         children.elementAt(selectedCardIndex!) as SpriteComponent;
  //     cardComponent.position += event.localDelta;
  //   }
  // }

  // @override
  // void onDragEnd(DragEndEvent event) {
  //   super.onDragEnd(event);

  //   // Ensure this method is called in the correct context
  //   if (selectedCardIndex == null) return;

  //   final cardComponent =
  //       children.elementAt(selectedCardIndex!) as SpriteComponent;

  //   // Convert card position to world space
  //   final cardWorldPosition =
  //       PositionUtils.localToGlobal(cardComponent.position, this);
  //   // print('Card World Position: $cardWorldPosition');

  //   final mobs = parent!.children.whereType<MobSprite>();
  //   // print("mobs $mobs");
  //   for (final mob in mobs) {
  //     final playingArea = mob.children.whereType<PlayingAreaComponent>().first;
  //     // print('PlayingArea: $playingArea');

  //     if (playingArea.parent is PositionComponent) {
  //       final areaWorldPosition = PositionUtils.localToGlobal(
  //           playingArea.position, playingArea.parent! as PositionComponent);
  //       final areaWorldRect = Rect.fromLTWH(areaWorldPosition.x,
  //           areaWorldPosition.y, playingArea.size.x, playingArea.size.y);

  //       // print('PlayingArea World Position: $areaWorldPosition');
  //       // print('PlayingArea World Rect: $areaWorldRect');

  //       if (areaWorldRect.contains(cardWorldPosition.toOffset())) {
  //         // print('Card accepted!');
  //         remove(cardComponent);
  //         // playingArea.acceptCard(cardComponent);
  //         originalPositions.removeAt(selectedCardIndex!);
  //         selectedCardIndex = null;
  //         return; // Exit the loop after accepting the card
  //       }
  //     }
  //   }

  //   // Reset card position if not accepted
  //   cardComponent.position = originalPositions[selectedCardIndex!];
  //   selectedCardIndex = null;
  // }

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
}
// }
