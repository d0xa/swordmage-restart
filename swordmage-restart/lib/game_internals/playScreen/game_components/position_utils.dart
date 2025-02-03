import 'package:flame/components.dart';

class PositionUtils {
  static Vector2 localToGlobal(
      Vector2 localPosition, PositionComponent component) {
    return component.position + localPosition;
  }

  static Vector2 globalToLocal(
      Vector2 globalPosition, PositionComponent component) {
    return globalPosition - component.position;
  }

  static Vector2 convertPosition(Vector2 position, PositionComponent source) {
    // Convert position from source component's local space to game's global space
    final absolutePosition = source.position + position;
    return absolutePosition;
  }

  static Vector2 convertBetweenComponents(
      Vector2 position, PositionComponent source, PositionComponent target) {
    // Convert to global space
    final globalPosition = convertPosition(position, source);

    // Convert from global to target's local space
    final localPosition = globalPosition - target.position;
    return localPosition;
  }
}
