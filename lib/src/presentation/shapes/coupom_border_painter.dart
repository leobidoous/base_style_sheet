import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class CouponBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.009523810, size.height * 0.08181818);
    path_0.cubicTo(
      size.width * 0.009523810,
      size.height * 0.04165200,
      size.width * 0.02089435,
      size.height * 0.009090909,
      size.width * 0.03492063,
      size.height * 0.009090909,
    );
    path_0.lineTo(size.width * 0.9650794, size.height * 0.009090909);
    path_0.cubicTo(
      size.width * 0.9791048,
      size.height * 0.009090909,
      size.width * 0.9904762,
      size.height * 0.04165200,
      size.width * 0.9904762,
      size.height * 0.08181818,
    );
    path_0.lineTo(size.width * 0.9904762, size.height * 0.3761909);
    path_0.cubicTo(
      size.width * 0.9813746,
      size.height * 0.3515045,
      size.width * 0.9690825,
      size.height * 0.3363636,
      size.width * 0.9555556,
      size.height * 0.3363636,
    );
    path_0.cubicTo(
      size.width * 0.9275016,
      size.height * 0.3363636,
      size.width * 0.9047619,
      size.height * 0.4014855,
      size.width * 0.9047619,
      size.height * 0.4818182,
    );
    path_0.cubicTo(
      size.width * 0.9047619,
      size.height * 0.5621509,
      size.width * 0.9275016,
      size.height * 0.6272727,
      size.width * 0.9555556,
      size.height * 0.6272727,
    );
    path_0.cubicTo(
      size.width * 0.9690825,
      size.height * 0.6272727,
      size.width * 0.9813746,
      size.height * 0.6121318,
      size.width * 0.9904762,
      size.height * 0.5874455,
    );
    path_0.lineTo(size.width * 0.9904762, size.height * 0.8818182);
    path_0.cubicTo(
      size.width * 0.9904762,
      size.height * 0.9219818,
      size.width * 0.9791048,
      size.height * 0.9545455,
      size.width * 0.9650794,
      size.height * 0.9545455,
    );
    path_0.lineTo(size.width * 0.03492063, size.height * 0.9545455);
    path_0.cubicTo(
      size.width * 0.02089438,
      size.height * 0.9545455,
      size.width * 0.009523810,
      size.height * 0.9219818,
      size.width * 0.009523810,
      size.height * 0.8818182,
    );
    path_0.lineTo(size.width * 0.009523810, size.height * 0.6020964);
    path_0.cubicTo(
      size.width * 0.01766416,
      size.height * 0.6179845,
      size.width * 0.02750092,
      size.height * 0.6272727,
      size.width * 0.03809524,
      size.height * 0.6272727,
    );
    path_0.cubicTo(
      size.width * 0.06614794,
      size.height * 0.6272727,
      size.width * 0.08888889,
      size.height * 0.5621509,
      size.width * 0.08888889,
      size.height * 0.4818182,
    );
    path_0.cubicTo(
      size.width * 0.08888889,
      size.height * 0.4014855,
      size.width * 0.06614794,
      size.height * 0.3363636,
      size.width * 0.03809524,
      size.height * 0.3363636,
    );
    path_0.cubicTo(
      size.width * 0.02750092,
      size.height * 0.3363636,
      size.width * 0.01766416,
      size.height * 0.3456518,
      size.width * 0.009523810,
      size.height * 0.3615400,
    );
    path_0.lineTo(size.width * 0.009523810, size.height * 0.08181818);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.grey;
    canvas.drawShadow(path_0, Colors.grey, 2.0, false);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
