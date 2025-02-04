import 'package:flame/components.dart';

class PositionUtils {
  static Vector2 globalToLocal(
      Vector2 globalPosition, PositionComponent component) {
    // Start with the global position
    Vector2 localPosition = globalPosition.clone();

    // Traverse up the parent hierarchy to adjust for each parent's position
    PositionComponent? current = component;
    while (current != null) {
      localPosition -= current.position;
      current = current.parent is PositionComponent
          ? current.parent as PositionComponent
          : null;
    }

    return localPosition;
  }

  static Vector2 localToGlobal(
      Vector2 localPosition, PositionComponent component) {
    // Start with the local position
    Vector2 globalPosition = localPosition.clone();

    // Traverse up the parent hierarchy to adjust for each parent's position
    PositionComponent? current = component;
    while (current != null) {
      globalPosition += current.position;
      current = current.parent is PositionComponent
          ? current.parent as PositionComponent
          : null;
    }

    return globalPosition;
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
