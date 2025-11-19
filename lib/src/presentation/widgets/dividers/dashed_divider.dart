import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.width,
    this.color,
    this.height = 1,
    this.direction = Axis.horizontal,
  }) : assert(width != double.infinity, 'Invalid width');

  final double height;
  final double? width;
  final Axis direction;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return CustomPaint(
          size: Size(width ?? constrains.maxWidth, height),
          painter: _LineDashedPainter(
            strokeWidth: height,
            lineSize: width ?? constrains.maxWidth,
            direction: direction,
            color: color,
          ),
        );
      },
    );
  }
}

class _LineDashedPainter extends CustomPainter {
  _LineDashedPainter({
    required this.strokeWidth,
    required this.lineSize,
    this.direction = Axis.horizontal,
    this.color,
  });
  final double lineSize;
  final double strokeWidth;
  final Axis direction;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint =
        Paint()
          ..color = color ?? Colors.grey
          ..strokeWidth = strokeWidth;
    var dashWidth = 5;
    var dashSpace = 5;
    double max = lineSize - dashWidth;
    double startX = 0;
    while (max >= 0) {
      switch (direction) {
        case Axis.horizontal:
          canvas.drawLine(
            Offset(startX, strokeWidth / 2),
            Offset(startX + dashWidth, strokeWidth / 2),
            paint,
          );
          break;
        case Axis.vertical:
          canvas.drawLine(
            Offset(strokeWidth, startX),
            Offset(strokeWidth, startX + dashWidth),
            paint,
          );
          break;
      }
      final space = (dashSpace + dashWidth);
      startX += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
