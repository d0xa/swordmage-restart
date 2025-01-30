class GameLevel {
  final int number;
  final List<String> monsterTypes;
  final int minMonsters;
  final int maxMonsters;
  final String background;
  final String sprite;

  GameLevel({
    required this.number,
    required this.monsterTypes,
    required this.minMonsters,
    required this.maxMonsters,
    this.background = 'default_background.png',
    this.sprite = 'default_sprite.png',
  });
}

final List<GameLevel> gameLevels = [
  GameLevel(
    number: 1,
    monsterTypes: ['Goblin'],
    minMonsters: 1,
    maxMonsters: 1,
  ),
  GameLevel(
    number: 2,
    monsterTypes: ['Goblin', 'Orc'],
    minMonsters: 1,
    maxMonsters: 3,
  ),
  GameLevel(
    number: 3,
    monsterTypes: ['Goblin', 'Orc'],
    minMonsters: 1,
    maxMonsters: 3,
  ),
  GameLevel(
    number: 4,
    monsterTypes: ['Goblin', 'Orc', 'Troll'],
    minMonsters: 2,
    maxMonsters: 4,
  ),
  // Add more levels as needed
];
