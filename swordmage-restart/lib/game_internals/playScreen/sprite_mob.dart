import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/playScreen/game_components/playing_area_component.dart';
import 'package:SwordMageRestart/game_internals/playScreen/mobs/mob_health_component.dart';
import 'package:SwordMageRestart/game_internals/playScreen/mobs/name_component.dart';
import 'package:SwordMageRestart/game_internals/playScreen/mobs/stamina_component.dart';
// import 'package:SwordMageRestart/game_internals/playing_area.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
// import 'package:flutter/material.dart';

class MobSprite extends SpriteAnimationComponent {
  bool _isSelected = false;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation onHitAnimation;
  late SpriteAnimation deathAnimation;
  bool isDying = false;
  // int health = 2;
  final Mob mob;
  late final HealthBarComponent healthBar;
  // late final PlayingArea playingArea;

  // MobSprite() : super(size: Vector2(64, 64));
  MobSprite({required this.mob}) : super(size: Vector2(75, 75)) {
    anchor = Anchor.centerRight; // Center the sprite

    // playingArea = PlayingArea();
  }
  @override
  void onMount() {
    super.onMount();

    // Determine desired offset
    const desiredXOffset = 60.0;
    const desiredYOffset = 0.0;
    // If mob is flipped, adjust X position but don't mirror PlayingArea
    // final effectiveXOffset = (scale.x < 0) ? -desiredXOffset : desiredXOffset;

    final playingAreaComp = PlayingAreaComponent(
      isMobArea: false,
    )
      ..scale.x = -1
      // ..scale = Vector2(1, 1)
      ..position = Vector2(desiredXOffset, desiredYOffset);
    // ..scale = Vector2(1, 1); // Force normal scale

    add(playingAreaComp);
  }

  @override
  Future<void> onLoad() async {
    // animation = idleAnimation;
    scale.x = -1; // Mirror the sprite horizontally
    // playing = true;
  }

  Future<void> loadAnimations(Images images) async {
    // await onLoad();
    final mobInfo = PositionComponent(
      position: Vector2(0, -20), // Position above sprite
    );

    final nameComponent = MobNameComponent(mob.name)..position = Vector2(50, 0);

    healthBar = HealthBarComponent(
      health: mob.health,
      maxHealth: mob.maxHealth,
    )..position = Vector2(0, 20);

    final staminaBar = StaminaBarComponent(
      stamina: mob.stamina.stamina,
      maxStamina: mob.maxStamina,
    )..position = Vector2(0, 35);

    // Add playing area below mob
    // final playingAreaComp = PlayingAreaComponent(
    //   // area: playingArea,
    //   isMobArea: false,
    // )..position = Vector2(30, -10);

    mobInfo.addAll([
      nameComponent,
      healthBar,
      staminaBar,
    ]);

    add(mobInfo);
    // add(playingAreaComp);
    await images.load('goblin/goblin_idle.png');
    await images.load('goblin/goblin_death.png');

    final idleSpriteSheet = SpriteSheet(
      image: images.fromCache('goblin/goblin_idle.png'),
      srcSize: Vector2(672, 672),
    );

    final deathSpriteSheet = SpriteSheet(
      image: images.fromCache('goblin/goblin_death.png'),
      srcSize: Vector2(672, 672),
    );

    idleAnimation = idleSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.4,
      // from: 0,
      to: 3,
    )..loop = true;

    onHitAnimation = deathSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.3,
      to: 2,
    )..loop = false;

    deathAnimation = deathSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.3,
      // to: 7,
    )..loop = false;

    animation = idleAnimation;
    playing = true;
  }

  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    _isSelected = value;
    if (!value) return; // Exit if deselected

    if (!isDying) {
      if (mob.health > 1) {
        // Play hit animation if mob still has health
        animation = onHitAnimation;
        mob.health--;
        healthBar.health = mob.health;
      } else {
        // Play death animation when health reaches 0
        isDying = true;
        animation = deathAnimation;
        mob.health--;
        healthBar.health = mob.health;
      }
    }
  }

  bool get isTurn => mob.isTurn;
  int get health => mob.health;
  int get maxHealth => mob.maxHealth;
  int get stamina => mob.stamina.stamina;
  int get maxStamina => mob.maxStamina;
  String get name => mob.name;

  @override
  void update(double dt) {
    super.update(dt);
    if (!_isSelected && !isDying) {
      animation = idleAnimation;
    }
  }
}
