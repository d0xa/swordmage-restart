import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_internals/stamina.dart';

class StaminaWidget extends StatelessWidget {
  const StaminaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final stamina = context.read<Stamina>();

    // return Consumer<Stamina>(
    //   builder: (context, stamina, child) {
    return Column(
      children: [
        Text('Stamina: ${stamina.stamina}',
            style: TextStyle(color: Colors.blue)),
        LinearProgressIndicator(
          value: stamina.stamina / 10, // Assuming max stamina is 10
          backgroundColor: Colors.grey,
          color: Colors.blue,
        ),
      ],
    );
  }
  // );
}
// }
