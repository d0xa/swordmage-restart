import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MobNameComponent extends TextComponent {
  MobNameComponent(String text)
      : super(
          text: text,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          // anchor: Anchor.topLeft,
        ) {
    // flipHorizontallyAroundCenter();
    flipHorizontally();
    // Prevent text from being flipped
    // flipHorizontally = false;
    // flipVertically = false;
  }

  @override
  void render(Canvas canvas) {
    // Save canvas state
    canvas.save();
    // Reset any transformations
    canvas.transform(Matrix4.identity().storage);
    // Render text
    super.render(canvas);
    // Restore canvas state
    canvas.restore();
  }
}
