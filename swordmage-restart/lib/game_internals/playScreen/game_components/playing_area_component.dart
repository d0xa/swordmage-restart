import 'dart:ui';

import 'package:SwordMageRestart/game_internals/playScreen/game_components/position_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
// import 'package:SwordMageRestart/game_internals/playScreen/game_components/position_utils.dart'
//     as PositionUtils;

class PlayingAreaComponent extends PositionComponent with DragCallbacks {
  final bool isMobArea;
  bool isHighlighted = false;
  static const double cardOffset = 10.0;
  static const int maxCards = 6;
  SpriteComponent? draggedCard;
  Vector2? originalCardPosition;

  PlayingAreaComponent({
    required this.isMobArea,
  }) : super(
          size: Vector2(110, 75),
          anchor: Anchor.topCenter,
        );

  SpriteComponent? _getCardAtPosition(Vector2 position) {
    for (final child in children) {
      if (child is SpriteComponent &&
          child.toRect().contains(position.toOffset())) {
        return child;
      }
    }
    return null;
  }

  void acceptCard(SpriteComponent cardComponent) {
    print("accepted card!");
    cardComponent.position = Vector2(
      size.x / 3 - cardComponent.size.x / 3,
      size.y / 3 - cardComponent.size.y / 3,
    );
    add(cardComponent);
    // print(cardComponent);
    // print("children count: ${children.length}");
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    canvas.drawRect(
      rect,
      Paint()
        ..color = isHighlighted
            ? Colors.green.withOpacity(0.3)
            : Colors.blue.withOpacity(0.3),
    );

    for (var i = 0; i < children.length; i++) {
      final cardComponent = children.elementAt(i) as SpriteComponent;
      canvas.save();
      canvas.translate(i * cardOffset, i * cardOffset);
      cardComponent.render(canvas);
      canvas.restore();
    }
  }

  // @override
  // void onMount() {
  //   super.onMount();
  //   size = Vector2(110, 75); // or whatever your size is
  // }

  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    isHighlighted = true;
    draggedCard = _getCardAtPosition(event.localPosition);

    if (draggedCard != null) {
      originalCardPosition = draggedCard!.position.clone();
      return true;
    }
    return false;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (draggedCard != null) {
      draggedCard!.position += event.delta;
    }
  }

  // @override
  // void onDragEnd(DragEndEvent event) {
  //   super.onDragEnd(event);
  //   isHighlighted = false;

  //   if (draggedCard != null && draggedCard!.parent is PositionComponent) {
  //     // 1. Get card's global position
  //     final cardGlobalPosition = PositionUtils.localToGlobal(
  //         draggedCard!.position, draggedCard!.parent! as PositionComponent);

  //     // 2. Convert card's global position to playing area's local position
  //     final cardPositionInPlayingArea =
  //         PositionUtils.globalToLocal(cardGlobalPosition, this);

  //     // 3. Use toRect() directly (now in the correct coordinate space)
  //     if (toRect()
  //         .toOffset()
  //         .toRect()
  //         .contains(cardPositionInPlayingArea.toOffset())) {
  //       acceptCard(draggedCard!);
  //     } else if (originalCardPosition != null) {
  //       draggedCard!.position = originalCardPosition!;
  //     }
  //   }
  //   draggedCard = null;
  //   originalCardPosition = null;
  // }
  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    isHighlighted = false;

    if (draggedCard != null && draggedCard!.parent is PositionComponent) {
      // 1. Get card's global position
      final cardGlobalPosition = PositionUtils.localToGlobal(
          draggedCard!.position, draggedCard!.parent! as PositionComponent);

      // 2. Convert card's global position to playing area's local coordinate space
      final cardPositionInPlayingArea =
          PositionUtils.globalToLocal(cardGlobalPosition, this);

      // 3. Create a local rect for the playing area
      final playingAreaRect = Rect.fromLTWH(0, 0, size.x, size.y);

      // 4. Check if the card falls within the local rect of the PlayingArea
      if (playingAreaRect.contains(cardPositionInPlayingArea.toOffset())) {
        acceptCard(draggedCard!);
      } else if (originalCardPosition != null) {
        draggedCard!.position = originalCardPosition!;
      }
    }
    draggedCard = null;
    originalCardPosition = null;
  }
}
