import 'package:flutter/material.dart';

///
/// This is the custom TabItem widget
/// It draws a rounded rectangle as indicator for the selected tab.
class RRectTabIndicator extends Decoration {
  final BoxPainter _painter;

  RRectTabIndicator({required Color color}) : _painter = _RRectPainter(color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _RRectPainter extends BoxPainter {
  final Paint _paint;

  _RRectPainter(Color color)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            offset.dx + cfg.size!.width * 0.3 / 2,
            offset.dy + cfg.size!.height * 0.3 / 2,
            cfg.size!.width * 0.7,
            cfg.size!.height * 0.7,
          ),
          const Radius.circular(25.0),
        ),
        _paint);
  }
}
