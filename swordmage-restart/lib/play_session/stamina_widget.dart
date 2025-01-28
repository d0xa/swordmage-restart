import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_internals/stamina.dart';

class StaminaWidget extends StatelessWidget {
  const StaminaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Stamina>(
      builder: (context, stamina, child) {
        return Column(
          children: [
            Text('Stamina: ${stamina.stamina}'),
            // ElevatedButton(
            //   onPressed: () {
            //     stamina.decrease(1); // Decrease stamina by 1 for demonstration
            //   },
            //   child: Text('Use Card'),
            // ),
          ],
        );
      },
    );
  }
}
