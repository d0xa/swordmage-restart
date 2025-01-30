import 'package:flutter/material.dart';

class EightBitCircle extends StatelessWidget {
  final int value;
  final Color color;

  const EightBitCircle({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: TextStyle(
            fontFamily: 'PressStart2P', // Use an 8-bit style font
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
