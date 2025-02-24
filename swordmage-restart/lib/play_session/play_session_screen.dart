// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:SwordMageRestart/game_internals/playScreen/flame_game.dart';
import 'package:SwordMageRestart/game_internals/health_bar.dart';
import 'package:SwordMageRestart/game_internals/levels/game_levels.dart';
import 'package:SwordMageRestart/game_internals/mob.dart';
import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:SwordMageRestart/play_session/end_turn_button.dart';
import 'package:SwordMageRestart/play_session/ghost_stamina_widget.dart';
import 'package:SwordMageRestart/play_session/mob_hand_widget.dart';
import 'package:SwordMageRestart/play_session/mob_stamina_widget.dart';
import 'package:SwordMageRestart/play_session/player_hand_widget.dart';
import 'package:SwordMageRestart/play_session/stamina_widget.dart';
import 'package:SwordMageRestart/player_progress/player_progress.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/board_state.dart';
import '../game_internals/score.dart';
import '../style/confetti.dart';
import '../style/palette.dart';
import 'board_widget.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  final GameLevel levelNumber;
  final Player player;
  const PlaySessionScreen(
      {super.key, required this.levelNumber, required this.player});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late final BoardState _boardState;
  late final GhostStamina _ghostStamina;
  final ValueNotifier<Mob?> _selectedMob = ValueNotifier<Mob?>(null);

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
    _boardState = BoardState(
      level: widget.levelNumber,
      player: widget.player,
      onWin: _playerWon,
    );
    _ghostStamina =
        GhostStamina(widget.player.stamina, widget.player.maxStamina);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _boardState),
        ChangeNotifierProvider.value(value: _boardState.player),
        ChangeNotifierProvider.value(value: _selectedMob),
        ChangeNotifierProvider.value(value: _ghostStamina),
        Provider<List<Mob>>.value(value: _boardState.mobs),
        ..._boardState.mobs
            .map((mob) => ChangeNotifierProvider.value(value: mob)),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          body: Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkResponse(
                      onTap: () => GoRouter.of(context).push('/settings'),
                      child: Image.asset(
                        'assets/images/settings.png',
                        semanticLabel: 'Settings',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Consumer<BoardState>(
                      builder: (context, boardState, child) {
                        return SizedBox(
                            height: 60,
                            width: 150,
                            child: HealthBar(
                              name: boardState.player.isTurn
                                  ? "*${boardState.player.name}"
                                  : boardState.player.name,
                              health: boardState.player.health,
                              maxHealth: boardState.player.maxHealth,
                              color: Colors.green,
                            ));
                      },
                    ),
                  ),

                  SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: GameWidget(game: SwordMageGame())),
                  Consumer<BoardState>(
                    builder: (context, boardState, child) {
                      return Column(
                        children: _boardState.mobs.map((mob) {
                          if (mob.isTurn) {
                            return ChangeNotifierProvider.value(
                              value: mob,
                              child: MobHandWidget(),
                            );
                          }
                          return Container();
                        }).toList(),
                      );
                    },
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: SingleChildScrollView(
                  //         child: Column(
                  //           children:
                  //               _boardState.mobs.asMap().entries.map((entry) {
                  //             Mob mob = entry.value;
                  //             return ValueListenableBuilder<Mob?>(
                  //               valueListenable: _selectedMob,
                  //               builder: (context, selectedMob, child) {
                  //                 return GestureDetector(
                  //                   onTap: () {
                  //                     if (_boardState.player.isTurn) {
                  //                       _selectedMob.value =
                  //                           selectedMob == mob ? null : mob;
                  //                       if (_selectedMob.value != null) {
                  //                         _boardState.applyDamageToSelectedMob(
                  //                             _selectedMob.value);
                  //                       }
                  //                     }
                  //                   },
                  //                 );
                  //               },
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Expanded(
                  //   flex: 6, // 60% of the screen height
                  //   child: BoardWidget(),
                  // ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Consumer<BoardState>(
                          builder: (context, boardState, child) {
                            return StaminaWidget();
                          },
                        ),
                      ),
                      const EndTurnButton(),
                    ],
                  ),
                  Expanded(
                    flex: 4, // 60% of the screen height

                    child: PlayerHandWidget(),
                  ),
                  // const PlayerHandWidget(),
                ],
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !_duringCelebration,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _boardState.dispose();
    super.dispose();
  }

  Future<void> _playerWon() async {
    _log.info('Player won');
    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.levelNumber.number);

    final player = _boardState.player;
    player.increaseMaxHealth();
    player.increaseMaxStamina();
    player.resetStamina();
    player.health = player.health + 1;
    // player.stamina.stamina = player.stamina.maxStamina;

    // TODO: replace with some meaningful score for the card game
    final score = Score(1, 1, DateTime.now().difference(_startOfPlay));

    // final playerProgress = context.read<PlayerProgress>();
    // playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}
