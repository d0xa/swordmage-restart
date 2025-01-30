// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:SwordMageRestart/game_internals/levels/game_levels.dart';
import 'package:SwordMageRestart/game_internals/levels/level_selector.dart';
import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:SwordMageRestart/lose_game/lose_game_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/score.dart';
import 'main_menu/main_menu_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: const ValueKey('play'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const LevelSelector(key: Key('level selection')),
          ),
          routes: [
            GoRoute(
              path: 'session/:levelNumber',
              pageBuilder: (context, state) {
                final levelNumber =
                    int.parse(state.pathParameters['levelNumber']!);
                final level = gameLevels
                    .firstWhere((level) => level.number == levelNumber);
                final player = state.extra as Player;

                return buildMyTransition<void>(
                  key: ValueKey('session-$levelNumber'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: PlaySessionScreen(
                    player: player,
                    levelNumber: level,
                    key: Key('play session $levelNumber'),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'won',
              redirect: (context, state) {
                if (state.extra == null) {
                  // Trying to navigate to a win screen without any data.
                  // Possibly by using the browser's back button.
                  return '/';
                }

                // Otherwise, do not redirect.
                return null;
              },
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final score = map['score'] as Score;

                return buildMyTransition<void>(
                  key: const ValueKey('won'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: WinGameScreen(
                    score: score,
                    key: const Key('win game'),
                  ),
                );
              },
            )
          ],
        ),
        GoRoute(
          path: '/lose',
          builder: (context, state) {
            // final score = state.extra as Score;
            // return LoseGameScreen(score: score);
            return LoseGameScreen();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
      ],
    ),
  ],
);
