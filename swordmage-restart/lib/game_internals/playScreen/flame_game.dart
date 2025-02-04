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
  SpriteComponent? draggedCard; // Declare draggedCard
  Vector2? originalCardPosition; // Declare originalCardPosition
  bool isHighlighted = false; // Declare isHighlighted

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
    )..position = Vector2(-10, size.y - 50);
    add(handComponent);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // if (!isPlayerTurn) return;

    final touchPoint = info.eventPosition.widget;

    // Check if a mob was tapped
    for (final mob in mobs) {
      if (mob.containsPoint(touchPoint)) {
        // print('Mob hit!');
        // print(touchPoint);

        // Deselect previous mob
        selectedMob?.isSelected = false;

        // Select new mob
        selectedMob = mob;
        mob.isSelected = true;

        // Play slash animation
        player.playSlash(mob.position).then((_) {
          mob.isSelected = false;
          selectedMob = null;
          isPlayerTurn = true;
        });
        break;
      }
    }
  }

  SpriteComponent? _getCardAtPosition(Vector2 position) {
    final handComponent = children.whereType<PlayerHandComponent>().first;
    for (final child in handComponent.children) {
      if (child is SpriteComponent &&
          child.toRect().contains(position.toOffset())) {
        return child;
      }
    }
    return null;
  }

  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    draggedCard = _getCardAtPosition(event.localPosition);

    if (draggedCard != null) {
      originalCardPosition = draggedCard!.position.clone();
      return true;
    }
    return false;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (draggedCard != null) {
      draggedCard!.position += event.delta;
    }
  }

  void acceptCard(
    SpriteComponent cardComponent,
    PlayingAreaComponent playingArea,
    PlayerHandComponent handComponent,
  ) {
    // This is a safe check to prevent adding the same card multiple times.
    if (!playingArea.children.contains(cardComponent)) {
      cardComponent.removeFromParent();
      playingArea.acceptCard(cardComponent);
    } else {
      print("Card was already in the playing area, skipping add.");
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    isHighlighted = false;

    if (draggedCard != null) {
      // Convert card position to global coordinates
      final cardGlobalPosition = PositionUtils.localToGlobal(
          draggedCard!.position, draggedCard!.parent! as PositionComponent);
      bool cardAccepted = false;
      for (final mob in mobs) {
        var playingArea = mob.children.whereType<PlayingAreaComponent>().first;
        final mobPosition = mob.position;
        final playingAreaRect = Rect.fromLTWH(
          mobPosition.x,
          mobPosition.y,
          playingArea.size.x,
          playingArea.size.y,
        );

        if (isWithinRange(cardGlobalPosition, playingAreaRect, 25)) {
          print("Card accepted in ${mob.name}'s playing area");

          if (!cardAccepted) {
            draggedCard!.removeFromParent();
            playingArea.acceptCard(draggedCard!);
            cardAccepted = true;
            break;
          }
        }
      }

      final handComponent = children.whereType<PlayerHandComponent>().first;
      if (!cardAccepted && originalCardPosition != null) {
        draggedCard!.position = originalCardPosition!;
        handComponent.selectedCardIndex = null;
      }
      draggedCard = null;
      originalCardPosition = null;
    }
  }

  bool isWithinRange(
      Vector2 cardGlobalPosition, Rect playingAreaBounds, double range) {
    final cardX = cardGlobalPosition.x;
    final cardY = cardGlobalPosition.y;

    final areaLeft = playingAreaBounds.left;
    final areaTop = playingAreaBounds.top;
    final areaRight = playingAreaBounds.right;
    final areaBottom = playingAreaBounds.bottom;

    // Calculate the extended bounds based on the range.
    final extendedLeft = areaLeft - range * 2;
    final extendedTop = areaTop - range;
    final extendedRight = areaRight + range;
    final extendedBottom = areaBottom - range;

    // Efficiently check if the card's position is within the extended bounds.
    return cardX >= extendedLeft &&
        cardX <= extendedRight &&
        cardY >= extendedTop &&
        cardY <= extendedBottom;
  }
}
