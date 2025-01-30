import 'package:flutter/foundation.dart';
import 'playing_card.dart';
import 'mob.dart';
import 'player.dart';

@immutable
class PlayingCardDragData {
  final PlayingCard card;
  final dynamic holder; // This can be either Player or Mob

  const PlayingCardDragData(this.card, this.holder);
}
