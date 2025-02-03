import 'dart:ui';

import 'package:SwordMageRestart/game_internals/board_state.dart';
import 'package:SwordMageRestart/game_internals/levels/game_levels.dart';
import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/playScreen/game_components/player_hand_component.dart';
import 'package:SwordMageRestart/game_internals/playScreen/game_components/playing_area_component.dart';
import 'package:SwordMageRestart/game_internals/playScreen/game_components/position_utils.dart';
import 'package:SwordMageRestart/game_internals/playScreen/sprite_mob.dart';
import 'package:SwordMageRestart/game_internals/playScreen/sprite_player.dart';
import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class SwordMageGame extends FlameGame with TapDetector, DragCallbacks {
  late PlayerSprite player;
  final List<MobSprite> mobs = [];
  MobSprite? selectedMob;
  bool isPlayerTurn = true;
  late final BoardState boardState;

  @override
  Future<void> onLoad() async {
    boardState = BoardState(
      level: GameLevel(
        number: 1,
        monsterTypes: ['Goblin'],
        minMonsters: 1,
        maxMonsters: 1,
      ),
      player: Player(
        name: 'Chacho',
        health: 10,
        maxHealth: 10,
        stamina: 5,
        maxStamina: 5,
        speed: 10,
      ),
      onWin: () {
        print("ya won ya nerd");
      },
    );
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
      )..position = Vector2(size.x - 100, (i + 0.8) * size.y / 3.5);

      await goblin.loadAnimations(images);
      mobs.add(goblin);
      add(goblin);
    }
    final handComponent = PlayerHandComponent(
      boardState: boardState,
      position: Vector2(-10, size.y - 50),
    );
    add(handComponent);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final handComponent = children.whereType<PlayerHandComponent>().first;
    if (handComponent.selectedCardIndex != null) {
      final cardComponent = handComponent.children
          .elementAt(handComponent.selectedCardIndex!) as SpriteComponent;
      cardComponent.position += event.delta;
    }
  }

  // @override
  // void onDragEnd(DragEndEvent event) {
  //   super.onDragEnd(event);
  //   final handComponent = children.whereType<PlayerHandComponent>().first;
  //   if (handComponent.selectedCardIndex == null) return;

  //   final cardComponent = handComponent.children
  //       .elementAt(handComponent.selectedCardIndex!) as SpriteComponent;

  //   final cardWorldPosition =
  //       PositionUtils.localToGlobal(cardComponent.position, handComponent);

  //   for (final mob in mobs) {
  //     final playingArea = mob.children.whereType<PlayingAreaComponent>().first;
  //     print(playingArea);

  //     if (playingArea.parent is PositionComponent) {
  //       final areaWorldPosition = PositionUtils.localToGlobal(
  //           playingArea.position, playingArea.parent! as PositionComponent);
  //       final areaWorldRect = Rect.fromLTWH(areaWorldPosition.x,
  //           areaWorldPosition.y, playingArea.size.x, playingArea.size.y);

  //       if (areaWorldRect.contains(cardWorldPosition.toOffset())) {
  //         playingArea.acceptCard(cardComponent);
  //         handComponent.remove(cardComponent);
  //         handComponent.originalPositions
  //             .removeAt(handComponent.selectedCardIndex!);
  //         handComponent.selectedCardIndex = null;
  //         return; // Important: Exit the loop after accepting the card
  //       }
  //     }
  //   }

  //   // Reset card position if not accepted.
  //   cardComponent.position =
  //       handComponent.originalPositions[handComponent.selectedCardIndex!];
  //   handComponent.selectedCardIndex = null;
  // }

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
