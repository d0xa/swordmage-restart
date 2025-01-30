import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobStaminaBar extends StatelessWidget {
  // final int stamina;
  // final int maxStamina;
  // final Color color;

  const MobStaminaBar({
    super.key,
    // required this.stamina,
    // required this.maxStamina,
    // required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // final mob = context.read<Mob>();

    return Consumer<Mob>(// Wrap with Consumer<Mob>
        builder: (context, mob, child) {
      // Access mob here
      return Container(
        width: 100,
        height: 10,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor:
                  mob.stamina.stamina / mob.maxStamina, // Use mob.stamina
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Center(
              // Center the text
              child: Text(
                  '${mob.stamina.stamina}/${mob.maxStamina}', // Use mob.stamina
                  style: TextStyle(color: Colors.black, fontSize: 8)),
            ),
          ],
        ),
      );
    });
  }
}
