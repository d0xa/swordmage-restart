import 'dart:math';
import 'package:SwordMageRestart/game_internals/mob.dart';

class Monsters {
  static final Random _random = Random();

  static Mob createGoblin(int index) {
    int maxHealth = _random.nextInt(3) + 1;
    int maxStamina = _random.nextInt(3) + 1;
    return Mob(
      name: 'Goblin $index',
      health: maxHealth,
      maxHealth: maxHealth,
      speed: _random.nextInt(3) + 1,
      initialStamina: maxStamina,
      maxStamina: maxStamina,
      mobType: 'Goblin',
    );
  }

  static Mob createOrc(int index) {
    int maxHealth = _random.nextInt(3) + 2;
    int maxStamina = _random.nextInt(3) + 2;
    return Mob(
      name: 'Orc $index',
      health: maxHealth,
      maxHealth: maxHealth,
      speed: _random.nextInt(3) + 2,
      initialStamina: maxStamina,
      maxStamina: maxStamina,
      mobType: 'Orc',
    );
  }

  static Mob createMonster(int index, String type, int minStat, int maxStat) {
    int maxHealth = _random.nextInt(maxStat - minStat + 1) + minStat;
    int maxStamina = _random.nextInt(maxStat - minStat + 1) + minStat;
    return Mob(
      name: '$type $index',
      health: maxHealth,
      maxHealth: maxHealth,
      speed: _random.nextInt(maxStat - minStat + 1) + minStat,
      initialStamina: maxStamina,
      maxStamina: maxStamina,
      mobType: type,
    );
  }

  static List<Mob> generateMobs(int count) {
    List<Mob> mobs = [];
    List<Mob Function(int)> monsterCreators = [
      createGoblin,
      createOrc,
      (index) => createMonster(index, 'Troll', 3, 5),
      (index) => createMonster(index, 'Dragon', 4, 5),
      (index) => createMonster(index, 'Demon', 5, 6),
    ];

    for (int i = 1; i <= count; i++) {
      int randomIndex = _random.nextInt(monsterCreators.length);
      mobs.add(monsterCreators[randomIndex](i));
    }

    return mobs;
  }
}
