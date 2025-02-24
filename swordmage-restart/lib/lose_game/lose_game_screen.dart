// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:SwordMageRestart/player_progress/player_progress.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../game_internals/score.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class LoseGameScreen extends StatelessWidget {
  // final Score score;

  const LoseGameScreen({
    super.key,
    // required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gap,
            const Center(
              child: Text(
                'You Lose :(',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: Text(
                  // 'Score: ${score.score}\n'
                  // 'Time: ${score.formattedTime}',
                  // style: const TextStyle(
                  //     fontFamily: 'Permanent Marker', fontSize: 20),
                  "Womp Womp"),
            ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            context.read<PlayerProgress>().reset();
            final messenger = ScaffoldMessenger.of(context);
            messenger.showSnackBar(const SnackBar(
                content: Text('Player progress has been reset.')));
            GoRouter.of(context).go('/');
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
