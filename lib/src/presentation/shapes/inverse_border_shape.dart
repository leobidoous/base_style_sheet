import 'package:flutter/material.dart';

// [InverseBorderShape] constrói a borda invertida do ticket não encontrado
class InverseBorderShape extends ShapeBorder {
  const InverseBorderShape({required this.radius, required this.pathWidth});
  final double radius;
  final double pathWidth;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect, textDirection: textDirection!), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _createPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => InverseBorderShape(
        radius: radius,
        pathWidth: 5,
      );

  Path _createPath(Rect rect) {
    final innerRadius = radius + pathWidth;
    final innerRect = Rect.fromLTRB(
      rect.left + pathWidth,
      rect.top + pathWidth,
      rect.right - pathWidth,
      rect.bottom - pathWidth,
    );

    final outer = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      _createBevels(rect, radius),
    );
    final inner = Path.combine(
      PathOperation.difference,
      Path()..addRect(innerRect),
      _createBevels(rect, innerRadius),
    );
    return Path.combine(PathOperation.difference, outer, inner);
  }

  Path _createBevels(Rect rect, double radius) {
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(rect.left, rect.top + rect.height),
          radius: radius,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(rect.left + rect.width, rect.top + rect.height),
          radius: radius,
        ),
      );
  }
}
