import 'dart:async';
import 'package:flutter/material.dart';

class TurnChangeDialog extends StatefulWidget {
  final Color color;
  const TurnChangeDialog({super.key, required this.color});

  @override
  _TurnChangeDialogState createState() => _TurnChangeDialogState();
}

class _TurnChangeDialogState extends State<TurnChangeDialog> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          border: Border.all(color: widget.color, width: 5),
          boxShadow: [
            BoxShadow(
              color: widget.color,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TURN CHANGE',
              style: TextStyle(
                fontFamily: 'PressStart2P', // Use an 8-bit style font
                fontSize: 24,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: widget.color,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
