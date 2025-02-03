import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class StaminaBarComponent extends PositionComponent {
  final int stamina;
  final int maxStamina;
  static const barHeight = 8.0;

  StaminaBarComponent({
    required this.stamina,
    required this.maxStamina,
  }) : super(size: Vector2(50, barHeight));

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      size.toRect(),
      Paint()..color = Colors.grey,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x * (stamina / maxStamina), height),
      Paint()..color = Colors.blue,
    );
  }
}
