import 'dart:math';

import 'package:flutter/material.dart';

class EdgePainter extends CustomPainter {
  double x1, y1, x2, y2;
  String weight;
  double radius;
  bool selfEdge = false;
  Color color;

  EdgePainter(this.x1, this.y1, this.x2, this.y2, this.weight, this.radius, this.selfEdge, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    if(!selfEdge){
      Paint pencil = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.fill;

      double angle = atan2(y2 - y1, x2 - x1);
      const arrowSize = 10.0;
      const arrowAngle = 25 * pi / 180;

      Path arrowPath = Path()
        ..moveTo(x2, y2)
        ..lineTo(x2 - arrowSize * cos(angle - arrowAngle),
            y2 - arrowSize * sin(angle - arrowAngle))
        ..lineTo(x2 - arrowSize * cos(angle + arrowAngle),
            y2 - arrowSize * sin(angle + arrowAngle))
        ..close();
      canvas.drawPath(arrowPath, pencil);

      Paint edge = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      Path edgePath = Path()
        ..moveTo(x1, y1)
        ..lineTo(x2, y2)
        ..close();
      canvas.drawPath(edgePath, edge);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: weight,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.rtl,
      );

      textPainter.layout();
      if(x1 < x2){
        textPainter.paint(canvas, Offset(x1 + (x2 - x1) / 2, y1 + (y2 - y1) / 2));
      } else {
        textPainter.paint(canvas, Offset(x2 + (x1 - x2) / 2, y2 + (y1 - y2) / 2));
      }
    } else {
      Paint pencil = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.fill;

      Path pencilPath = Path()
        ..moveTo(x1, y1)
        ..quadraticBezierTo(x1 - radius * 2, y2 - radius * 2, x2, y2);
      canvas.drawPath(pencilPath, pencil);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: weight,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x2, y1 - 30));
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}