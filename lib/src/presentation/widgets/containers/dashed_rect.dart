import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Defines which corners should have a concave (inverted) radius.
class ConcaveRadius {
  const ConcaveRadius({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomLeft = 0,
    this.bottomRight = 0,
  });

  /// All corners concave with the same radius.
  const ConcaveRadius.all(double radius)
    : topLeft = radius,
      topRight = radius,
      bottomLeft = radius,
      bottomRight = radius;

  /// Only specific corners concave.
  const ConcaveRadius.only({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomLeft = 0,
    this.bottomRight = 0,
  });

  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConcaveRadius &&
        other.topLeft == topLeft &&
        other.topRight == topRight &&
        other.bottomLeft == bottomLeft &&
        other.bottomRight == bottomRight;
  }

  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomLeft, bottomRight);
}

/// A dashed rectangle that supports concave (inverted) radius on any corner.
///
/// Use [concaveRadius] to select which corners get the inverted curve,
/// similar to `BorderRadius.only`. Corners without concave radius
/// will use the normal convex [borderRadius].
class DashedRect extends StatelessWidget {
  const DashedRect({
    super.key,
    required this.child,
    this.shadowColor,
    this.dashGap = 5.0,
    this.elevation = 4,
    this.padding = .zero,
    this.dashWidth = 5.0,
    this.strokeWidth = 1.0,
    this.borderRadius = .zero,
    this.borderColor = Colors.black,
    this.concaveRadius = const ConcaveRadius(),
  });

  final Widget child;
  final double dashGap;
  final double dashWidth;
  final Color? borderColor;
  final double strokeWidth;
  final EdgeInsets padding;

  /// Normal convex border radius (used for corners without concave).
  final BorderRadius borderRadius;

  /// Concave (inverted) radius per corner. Overrides [borderRadius] where set.
  final ConcaveRadius concaveRadius;

  /// Shadow elevation behind the shape. Set to 0 for no shadow.
  final double elevation;

  /// Shadow color. Defaults to [Colors.black26].
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CouponDashedRectPainter(
        dashGap: dashGap,
        dashWidth: dashWidth,
        elevation: elevation,
        borderColor: borderColor,
        shadowColor: shadowColor,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
        concaveRadius: concaveRadius,
      ),
      child: ClipPath(
        clipper: _CouponPathClipper(
          strokeWidth: strokeWidth,
          borderRadius: borderRadius,
          concaveRadius: concaveRadius,
        ),
        child: Padding(
          padding: padding + EdgeInsets.all(strokeWidth / 2),
          child: child,
        ),
      ),
    );
  }
}

class _CouponDashedRectPainter extends CustomPainter {
  _CouponDashedRectPainter({
    required this.borderColor,
    required this.dashGap,
    required this.dashWidth,
    required this.elevation,
    required this.strokeWidth,
    required this.shadowColor,
    required this.borderRadius,
    required this.concaveRadius,
  });

  final double dashGap;
  final double dashWidth;
  final double elevation;
  final Color? borderColor;
  final Color? shadowColor;
  final double strokeWidth;
  final BorderRadius borderRadius;
  final ConcaveRadius concaveRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    // Draw shadow if shadowColor != null
    if (shadowColor != null) {
      canvas.drawShadow(path, shadowColor!, elevation, false);
    }

    // Draw dashed border
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = borderColor ?? Colors.black
      ..style = .stroke;

    final dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, paint);
  }

  Path _buildPath(Size size) {
    final path = Path();
    final s = strokeWidth / 2;

    final left = s;
    final top = s;
    final right = size.width - s;
    final bottom = size.height - s;

    // Determine radius for each corner (concave wins over convex if > 0)
    final tlConcave = concaveRadius.topLeft;
    final trConcave = concaveRadius.topRight;
    final blConcave = concaveRadius.bottomLeft;
    final brConcave = concaveRadius.bottomRight;

    final tlConvex = tlConcave > 0 ? 0.0 : borderRadius.topLeft.x;
    final trConvex = trConcave > 0 ? 0.0 : borderRadius.topRight.x;
    final blConvex = blConcave > 0 ? 0.0 : borderRadius.bottomLeft.x;
    final brConvex = brConcave > 0 ? 0.0 : borderRadius.bottomRight.x;

    // Start after top-left corner
    if (tlConcave > 0) {
      path.moveTo(left + tlConcave, top);
    } else if (tlConvex > 0) {
      path.moveTo(left + tlConvex, top);
    } else {
      path.moveTo(left, top);
    }

    // --- Top edge → top-right ---
    if (trConcave > 0) {
      path.lineTo(right - trConcave, top);
      // Concave top-right
      path.arcToPoint(
        Offset(right, top + trConcave),
        radius: Radius.circular(trConcave),
        clockwise: false,
      );
    } else if (trConvex > 0) {
      path.lineTo(right - trConvex, top);
      path.arcToPoint(
        Offset(right, top + trConvex),
        radius: Radius.circular(trConvex),
      );
    } else {
      path.lineTo(right, top);
    }

    // --- Right edge → bottom-right ---
    if (brConcave > 0) {
      path.lineTo(right, bottom - brConcave);
      // Concave bottom-right
      path.arcToPoint(
        Offset(right - brConcave, bottom),
        radius: Radius.circular(brConcave),
        clockwise: false,
      );
    } else if (brConvex > 0) {
      path.lineTo(right, bottom - brConvex);
      path.arcToPoint(
        Offset(right - brConvex, bottom),
        radius: Radius.circular(brConvex),
      );
    } else {
      path.lineTo(right, bottom);
    }

    // --- Bottom edge → bottom-left ---
    if (blConcave > 0) {
      path.lineTo(left + blConcave, bottom);
      // Concave bottom-left
      path.arcToPoint(
        Offset(left, bottom - blConcave),
        radius: Radius.circular(blConcave),
        clockwise: false,
      );
    } else if (blConvex > 0) {
      path.lineTo(left + blConvex, bottom);
      path.arcToPoint(
        Offset(left, bottom - blConvex),
        radius: Radius.circular(blConvex),
      );
    } else {
      path.lineTo(left, bottom);
    }

    // --- Left edge → top-left ---
    if (tlConcave > 0) {
      path.lineTo(left, top + tlConcave);
      // Concave top-left
      path.arcToPoint(
        Offset(left + tlConcave, top),
        radius: Radius.circular(tlConcave),
        clockwise: false,
      );
    } else if (tlConvex > 0) {
      path.lineTo(left, top + tlConvex);
      path.arcToPoint(
        Offset(left + tlConvex, top),
        radius: Radius.circular(tlConvex),
      );
    } else {
      path.lineTo(left, top);
    }

    path.close();
    return path;
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
  bool shouldRepaint(_CouponDashedRectPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.concaveRadius != concaveRadius ||
        oldDelegate.elevation != elevation ||
        oldDelegate.shadowColor != shadowColor;
  }
}

/// Clips the child widget to match the same path as the dashed border painter.
class _CouponPathClipper extends CustomClipper<Path> {
  _CouponPathClipper({
    required this.strokeWidth,
    required this.borderRadius,
    required this.concaveRadius,
  });

  final double strokeWidth;
  final BorderRadius borderRadius;
  final ConcaveRadius concaveRadius;

  @override
  Path getClip(Size size) {
    final path = Path();
    final s = strokeWidth / 2;

    final left = s;
    final top = s;
    final right = size.width - s;
    final bottom = size.height - s;

    final tlConcave = concaveRadius.topLeft;
    final trConcave = concaveRadius.topRight;
    final blConcave = concaveRadius.bottomLeft;
    final brConcave = concaveRadius.bottomRight;

    final tlConvex = tlConcave > 0 ? 0.0 : borderRadius.topLeft.x;
    final trConvex = trConcave > 0 ? 0.0 : borderRadius.topRight.x;
    final blConvex = blConcave > 0 ? 0.0 : borderRadius.bottomLeft.x;
    final brConvex = brConcave > 0 ? 0.0 : borderRadius.bottomRight.x;

    // Start after top-left corner
    if (tlConcave > 0) {
      path.moveTo(left + tlConcave, top);
    } else if (tlConvex > 0) {
      path.moveTo(left + tlConvex, top);
    } else {
      path.moveTo(left, top);
    }

    // --- Top edge → top-right ---
    if (trConcave > 0) {
      path.lineTo(right - trConcave, top);
      path.arcToPoint(
        Offset(right, top + trConcave),
        radius: Radius.circular(trConcave),
        clockwise: false,
      );
    } else if (trConvex > 0) {
      path.lineTo(right - trConvex, top);
      path.arcToPoint(
        Offset(right, top + trConvex),
        radius: Radius.circular(trConvex),
      );
    } else {
      path.lineTo(right, top);
    }

    // --- Right edge → bottom-right ---
    if (brConcave > 0) {
      path.lineTo(right, bottom - brConcave);
      path.arcToPoint(
        Offset(right - brConcave, bottom),
        radius: Radius.circular(brConcave),
        clockwise: false,
      );
    } else if (brConvex > 0) {
      path.lineTo(right, bottom - brConvex);
      path.arcToPoint(
        Offset(right - brConvex, bottom),
        radius: Radius.circular(brConvex),
      );
    } else {
      path.lineTo(right, bottom);
    }

    // --- Bottom edge → bottom-left ---
    if (blConcave > 0) {
      path.lineTo(left + blConcave, bottom);
      path.arcToPoint(
        Offset(left, bottom - blConcave),
        radius: Radius.circular(blConcave),
        clockwise: false,
      );
    } else if (blConvex > 0) {
      path.lineTo(left + blConvex, bottom);
      path.arcToPoint(
        Offset(left, bottom - blConvex),
        radius: Radius.circular(blConvex),
      );
    } else {
      path.lineTo(left, bottom);
    }

    // --- Left edge → top-left ---
    if (tlConcave > 0) {
      path.lineTo(left, top + tlConcave);
      path.arcToPoint(
        Offset(left + tlConcave, top),
        radius: Radius.circular(tlConcave),
        clockwise: false,
      );
    } else if (tlConvex > 0) {
      path.lineTo(left, top + tlConvex);
      path.arcToPoint(
        Offset(left + tlConvex, top),
        radius: Radius.circular(tlConvex),
      );
    } else {
      path.lineTo(left, top);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_CouponPathClipper oldClipper) {
    return oldClipper.strokeWidth != strokeWidth ||
        oldClipper.borderRadius != borderRadius ||
        oldClipper.concaveRadius != concaveRadius;
  }
}
