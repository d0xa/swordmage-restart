import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:SwordMageRestart/play_session/ghost_stamina_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_internals/stamina.dart';

class StaminaWidget extends StatelessWidget {
  const StaminaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final player = context.read<Player>();

    // return Consumer<Stamina>(
    //   builder: (context, stamina, child) {

    // return Consumer<Player>(
    //   builder: (context, player, child) {
    //     return Column(
    //       children: [
    //         Text('Stamina: ${player.stamina}',
    //             style: TextStyle(color: Colors.orange)),
    //         LinearProgressIndicator(
    //           value: player.stamina / player.maxStamina,
    //           backgroundColor: Colors.grey,
    //           color: Colors.orange,
    //         ),
    //       ],
    //     );
    //   },
    // );
    return Consumer2<Player, GhostStamina>(
      builder: (context, player, ghostStamina, child) {
        return Column(
          children: [
            Stack(
              children: [
                LinearProgressIndicator(
                  value: player.stamina / player.maxStamina,
                  backgroundColor: Colors.grey,
                  color: Colors.white,
                ),
                LinearProgressIndicator(
                    value: ghostStamina.ghostStamina / player.maxStamina,
                    backgroundColor: Colors.transparent,
                    color: Colors.orange),
              ],
            ),
            Text('Stamina: ${ghostStamina.ghostStamina}',
                style: TextStyle(color: Colors.orange)),
          ],
        );
      },
    );
  }
  // );
}
// }
