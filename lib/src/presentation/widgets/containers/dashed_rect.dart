import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DashedRect extends StatelessWidget {
  const DashedRect({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.borderRadius = .zero,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.padding = .zero,
    this.dashGap = 5.0,
  });

  final Color color;
  final Widget child;
  final double dashGap;
  final double dashWidth;
  final double strokeWidth;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: color,
        dashGap: dashGap,
        dashWidth: dashWidth,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
      ),
      child: Padding(padding: padding + .all(strokeWidth / 2), child: child),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({
    required this.color,
    required this.dashGap,
    required this.dashWidth,
    required this.strokeWidth,
    required this.borderRadius,
  });

  final Color color;
  final double dashGap;
  final double dashWidth;
  final double strokeWidth;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final rRect = borderRadius.toRRect(rect);
    final path = Path()..addRRect(rRect);

    final dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source) {
    final dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final length = draw ? dashWidth : dashGap;
        final end = (distance + length).clamp(0, metric.length).toDouble();
        if (draw) {
          final extracted = metric.extractPath(distance, end);
          dashedPath.addPath(extracted, ui.Offset.zero);
        }
        distance = end;
        draw = !draw;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(_DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
