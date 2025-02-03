import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class PlayerSprite extends SpriteAnimationComponent {
  late SpriteAnimation idleAnimation;
  late SpriteAnimation slashAnimation;
  bool isSlashing = false;
  Vector2 originalPosition = Vector2.zero();
  int currentFrame = 0;

  PlayerSprite() : super(size: Vector2(128, 128));

  Future<void> loadAnimations(Images images) async {
    await images.load('swordsman/Idle.png');
    await images.load('swordsman/Slash.png');

    final idleSpriteSheet = SpriteSheet(
      image: images.fromCache('swordsman/Idle.png'),
      srcSize: Vector2(75, 75),
    );

    final slashSpriteSheet = SpriteSheet(
      image: images.fromCache('swordsman/Slash.png'),
      srcSize: Vector2(75, 75),
    );

    idleAnimation = idleSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.4,
      to: 1,
    )..loop = true;

    slashAnimation = slashSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.3,
      to: 7,
      // loop: false,
    )..loop = false;

    animation = idleAnimation;
    playing = true;
  }

  void resetAnimation() {
    currentFrame = 0;
    if (animation != null) {
      animation!.frames.first;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isSlashing && animation != idleAnimation) {
      animation = idleAnimation;
    }
  }

  Future<void> playSlash(Vector2 targetPosition) async {
    if (isSlashing) return;

    isSlashing = true;
    originalPosition = position.clone();

    // Move to target
    position = Vector2(targetPosition.x - 100,
        targetPosition.y); // Offset for better positioning
    animation = slashAnimation;

    // Wait for slash animation to complete
    await Future.delayed(Duration(milliseconds: 700));

    // Return to original position
    position = originalPosition;
    isSlashing = false;
  }
}
