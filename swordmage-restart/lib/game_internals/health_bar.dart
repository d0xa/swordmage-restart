import 'package:flutter/material.dart';

class HealthBar extends StatelessWidget {
  final String name;
  final int health;
  final int maxHealth;
  final Color color;

  const HealthBar({
    super.key,
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final healthPercentage = health / maxHealth;
    final healthColor = health > 0 ? color : Colors.grey;
    final excessDamage = health < 0 ? -health : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(color: healthColor)),
        Stack(
          children: [
            Container(
              width: 200,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            if (healthPercentage > 0)
              Positioned(
                left: 0,
                child: Container(
                  width: 200 * healthPercentage,
                  height: 20,
                  decoration: BoxDecoration(
                    color: healthColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            if (excessDamage > 0)
              Container(
                child: Text(
                  'Excess Damage: $excessDamage',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        Text('$health/$maxHealth', style: TextStyle(color: healthColor)),
      ],
    );
  }
}
