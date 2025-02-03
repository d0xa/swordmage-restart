import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthBarComponent extends PositionComponent {
  int health;
  final int maxHealth;
  final Color color;
  static const healthHeight = 10.0;

  HealthBarComponent({
    required this.health,
    required this.maxHealth,
    this.color = Colors.red,
  }) : super(size: Vector2(50, healthHeight));

  @override
  void render(Canvas canvas) {
    // Background
    canvas.drawRect(
      size.toRect(),
      Paint()..color = Colors.grey,
    );
    // Health
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x * (health / maxHealth), height),
      Paint()..color = color,
    );
  }
}
