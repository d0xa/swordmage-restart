import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/playScreen/sprite_mob.dart';
import 'package:flame/components.dart';

class MobComponent extends PositionComponent {
  final Mob mob;
  late final MobSprite sprite;

  MobComponent({
    required this.mob,
    required Vector2 position,
  }) : super(position: position) {
    // sprite = MobSprite()..health = mob.health;
  }

  @override
  Future<void> onLoad() async {
    await add(sprite);
  }

  void onHit() {
    mob.health--;
    sprite.isSelected = true;
  }

  bool get isDead => mob.health <= 0;
}
