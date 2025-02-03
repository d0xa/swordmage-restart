import 'dart:ui';

import 'package:SwordMageRestart/game_internals/board_state.dart';
import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/playScreen/sprite_mob.dart';
import 'package:SwordMageRestart/game_internals/playScreen/sprite_player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class SwordMageGame extends FlameGame with TapDetector {
  late PlayerSprite player;
  final List<MobSprite> mobs = [];
  MobSprite? selectedMob;
  bool isPlayerTurn = true;
  late final BoardState boardState;

  @override
  Future<void> onLoad() async {
    // Set white background
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFFFFFFFF),
    ));

    // Initialize player
    player = PlayerSprite()..position = Vector2(0, size.y / 2);
    await player.loadAnimations(images);
    add(player);

    // Add three mobs
    for (int i = 0; i < 3; i++) {
      final mobLogic = Mob(
        health: 3,
        speed: 1,
        initialStamina: 3,
        mobType: 'Goblin',
        name: 'Goblin ${i + 1}',
        maxHealth: 3,
        maxStamina: 3,
      );
      final goblin = MobSprite(
        mob: mobLogic,
        // position: Vector2(size.x - 150, (i + 1) * size.y / 4),
      )..position = Vector2(size.x - 100, (i + 1) * size.y / 4);

      await goblin.loadAnimations(images);
      mobs.add(goblin);
      add(goblin);
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    // if (!isPlayerTurn) return;

    final touchPoint = info.eventPosition.widget;

    // Check if a mob was tapped
    for (final mob in mobs) {
      if (mob.containsPoint(touchPoint)) {
        print('Mob hit!');

        // Deselect previous mob
        selectedMob?.isSelected = false;

        // Select new mob
        selectedMob = mob;
        mob.isSelected = true;

        // Play slash animation
        player.playSlash(mob.position).then((_) {
          // boardState.applyDamageToSelectedMob(mob);
          mob.isSelected = false;
          selectedMob = null;
          isPlayerTurn = true;
        });
        break;
      }
    }
  }
}
