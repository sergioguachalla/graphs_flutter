import 'package:flutter/material.dart';
import 'package:flutter_graphs/models/node_painter.dart';

class NodeModel extends StatelessWidget {

  Color color;
  double x, y, radius;
  String text;


  NodeModel(this.color, this.x, this.y, this.radius, this.text);

  bool isInBounds(Offset offset) {
    return (offset.dx - x) * (offset.dx - x) + (offset.dy - y) * (offset.dy - y) <= radius * radius;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NodePainter(color, x, y, radius, text),
    );

  }
  NodeModel copyWith({
    Color? color,
    double? x,
    double? y,
    double? radius,
    String? text,
  }) {
    return NodeModel(
      color ?? this.color,
      x ?? this.x,
      y ?? this.y,
      radius ?? this.radius,
      text ?? this.text,
    );
  }
}
