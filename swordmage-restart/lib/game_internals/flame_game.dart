import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class SwordMageGame extends FlameGame {
  late SpriteAnimationComponent swordsman;
  late Vector2 originalPosition; // Store the original position
  late Vector2 endPosition; // Store the end position
  bool isSlashing = false; // Track if the swordsman is slashing
  late SpriteAnimation idleAnimation;
  late SpriteAnimation slashAnimation;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load the idle and slashing sprite sheets
    await images.load('swordsman/Idle.png');
    await images.load('swordsman/Slash.png');

    // Create the idle sprite sheet
    final idleSpriteSheet = SpriteSheet(
      image: images.fromCache('swordsman/Idle.png'),
      srcSize: Vector2(75, 75), // Size of each frame in the sprite sheet
    );

    // Create the slashing sprite sheet
    final slashSpriteSheet = SpriteSheet(
      image: images.fromCache('swordsman/Slash.png'),
      srcSize: Vector2(75, 75), // Size of each frame in the sprite sheet
    );

    // Create the idle animation
    idleAnimation = idleSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.4, // Adjust the frame duration as needed
      to: 7, // Number of frames in the animation
    );

    // Create the slashing animation
    slashAnimation = slashSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1, // Adjust the frame duration as needed
      to: 7, // Number of frames in the animation
    );

    // Set the original and end positions
    originalPosition = Vector2(-50, 100);
    endPosition = Vector2(size.x - 128, 100);

    // Create and add the swordsman sprite animation component
    swordsman = SpriteAnimationComponent()
      ..animation = idleAnimation
      ..size = Vector2(128, 128) // Adjust the size to be twice as big
      ..position = originalPosition; // Start at the original position

    add(swordsman);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isSlashing) {
      // Move the swordsman to the right
      swordsman.position.x += 100 * dt; // Adjust the speed as needed

      // Check if the swordsman has reached the end position
      if (swordsman.position.x >= endPosition.x) {
        // Start the slashing animation
        isSlashing = true;
        swordsman.animation = slashAnimation;
        // swordsman.animation = idleAnimation;
      }
    } else {
      // Check if the slashing animation is complete
      if (swordsman.position == originalPosition) {
        // Reset the position and state
        swordsman.position = originalPosition;
        swordsman.animation = idleAnimation;
        isSlashing = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Fill the background with white color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFFFFFFFF),
    );
    super.render(canvas);
    // Render your game objects here if needed
  }
}
