import 'package:flutter/material.dart';

class NodePainter extends CustomPainter {

  Color color;
  double x, y, radius;
  String text;


  NodePainter(this.color, this.x, this.y, this.radius, this.text);

  @override
  void paint(Canvas canvas, Size size) {

    //Node circle
    Paint paint = Paint()
        ..color = Colors.indigoAccent
        ..style = PaintingStyle.fill;

    //Node border
    Paint paintBorder = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
    Path path = Path()
      ..addOval(Rect.fromCircle(center: Offset(x, y), radius: radius))
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, paintBorder);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


}