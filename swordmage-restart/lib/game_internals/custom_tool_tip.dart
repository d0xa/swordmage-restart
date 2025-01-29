import 'package:flutter/material.dart';

class CustomTooltip extends StatefulWidget {
  final String message;
  final Widget child;

  const CustomTooltip({required this.message, required this.child, super.key});

  @override
  _CustomTooltipState createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return MouseRegion(
    //   onEnter: (event) => _showTooltip(context, event.position),
    //   onExit: (event) => _hideTooltip(),
    //   child: widget.child,
    // );
    return GestureDetector(
      // onTap: () => _showTooltip(context),
      onLongPress: () => _showTooltip(context),
      child: widget.child,
    );
  }

  void _showTooltip(BuildContext context) {
    if (!mounted) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(context, position);
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(Duration(seconds: 2), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context, Offset position) {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy - 30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PressStart2P', // Use an 8-bit style font
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
