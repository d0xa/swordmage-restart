import 'dart:ui';

import 'package:SwordMageRestart/game_internals/playScreen/game_components/position_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
// import 'package:SwordMageRestart/game_internals/playScreen/game_components/position_utils.dart'
//     as PositionUtils;

class PlayingAreaComponent extends PositionComponent {
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
          // anchor: Anchor.topCenter,
        );
  @override
  Rect toRect() {
    return Rect.fromLTWH(
      0, // Local X
      0, // Local Y
      size.x, // Width
      size.y, // Height
    );
  }

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
    // print("Children before accept: ${children.length}");

    // Remove the card from its previous parent
    cardComponent.removeFromParent();

    // Calculate correct position based on current cards
    final slotIndex = children.length;
    cardComponent.position = Vector2(
        size.x / 2 - cardComponent.size.x / 2 + (slotIndex * cardOffset),
        size.y / 2 - cardComponent.size.y / 2);

    add(cardComponent);
    print("Card added to slot: $slotIndex");
    print("Children after accept: ${children.length}");
    print("Card's current parent: ${cardComponent.parent}");
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
    // print(children);
    // print(children.length);
    for (var i = 0; i < children.length - 5; i++) {
      final cardComponent = children.elementAt(i) as SpriteComponent;
      cardComponent.render(canvas);
    }
  }
}
