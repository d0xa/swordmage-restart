// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:SwordMageRestart/game_internals/playScreen/flame_game.dart';
import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();
    final player = context.watch<Player>();

    return GameWidget<SwordMageGame>(game: SwordMageGame());
  }

  // return Scaffold(
  //   backgroundColor: palette.backgroundMain,
  //   body: ResponsiveScreen(
  //     squarishMainArea: Center(
  //       child: Transform.rotate(
  //         angle: -0.1,
  //         child: const Text(
  //           'Swordmage Restart!',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontFamily: 'Permanent Marker',
  //             fontSize: 55,
  //             height: 1,
  //           ),
  //         ),
  //       ),
  //     ),
  //     rectangularMenuArea: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.height * 0.8,
  //           child: GameWidget<SwordMageGame>(
  //             game: SwordMageGame(),
  //           ),
  //         ),
  // MyButton(
  //   onPressed: () {
  //     audioController.playSfx(SfxType.buttonTap);
  //     GoRouter.of(context).go('/play', extra: player);
  //   },
  //   child: const Text('Play'),
  // ),
  // _gap,
  // MyButton(
  //   onPressed: () => GoRouter.of(context).push('/settings'),
  //   child: const Text('Settings'),
  // ),
  // _gap,
  // Padding(
  //   padding: const EdgeInsets.only(top: 32),
  //   child: ValueListenableBuilder<bool>(
  //     valueListenable: settingsController.audioOn,
  //     builder: (context, audioOn, child) {
  //       return IconButton(
  //         onPressed: () => settingsController.toggleAudioOn(),
  //         icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
  //       );
  //     },
  //   ),
  // ),
  // _gap,
  // const Text('Created by Chacho'),
  // _gap,
  //         ],
  //       ),
  //     ),
  //   );
  // }

  static const _gap = SizedBox(height: 10);
}
