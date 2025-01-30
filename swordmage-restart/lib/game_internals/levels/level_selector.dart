import 'package:SwordMageRestart/audio/audio_controller.dart';
import 'package:SwordMageRestart/audio/sounds.dart';
import 'package:SwordMageRestart/game_internals/levels/game_levels.dart';
import 'package:SwordMageRestart/game_internals/player.dart';
import 'package:SwordMageRestart/player_progress/player_progress.dart';
import 'package:SwordMageRestart/style/my_button.dart';
import 'package:SwordMageRestart/style/palette.dart';
import 'package:SwordMageRestart/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelSelector extends StatelessWidget {
  const LevelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();
    final player = context.watch<Player>();
    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Select level',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: gameLevels.length,
                itemBuilder: (context, index) {
                  final level = gameLevels[index];
                  final isUnlocked =
                      playerProgress.highestLevelReached >= level.number - 1;
                  final isCompleted =
                      playerProgress.highestLevelReached >= level.number;

                  return GestureDetector(
                    onTap: isUnlocked
                        ? () {
                            final audioController =
                                context.read<AudioController>();
                            audioController.playSfx(SfxType.buttonTap);
                            GoRouter.of(context).go(
                              '/play/session/${level.number}',
                              extra: player,
                            );
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isUnlocked ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              'Level ${level.number}',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
