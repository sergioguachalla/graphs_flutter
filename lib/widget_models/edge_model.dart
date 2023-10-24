import 'package:flutter/material.dart';
import 'package:flutter_graphs/models/edge_painter.dart';

import 'node_model.dart';

class EdgeModel extends StatelessWidget{
  double x1, y1, x2, y2;
  double radius;
  String weight;

  EdgeModel(this.x1, this.y1, this.x2, this.y2, this.radius, this.weight);

  @override
  Widget build(BuildContext context) {
    if (x1 == x2 && y1 == y2) {
      return CustomPaint(painter: EdgePainter
        (x1, y1 - radius,  x2 - radius, y2, weight,  radius,  true));
    }
    return CustomPaint(painter: EdgePainter
      (x1, y1, x2, y2, weight, radius, false));

  }
  EdgeModel copyWith({
    double? x1,
    double? y1,
    double? x2,
    double? y2,
    double? radius,
    String? weight,
  }) {
    return EdgeModel(
      x1 ?? this.x1,
      y1 ?? this.y1,
      x2 ?? this.x2,
      y2 ?? this.y2,
      radius ?? this.radius,
      weight ?? this.weight,


    );
  }
  bool isInsideScreen(double x, double y) {
    if (x >= x2 - radius - 20 && x <= x2 + radius + 20 && y >= y2 - radius - 20 && y <= y2 + radius + 20) {
      return true;
    }
    return false;
  }

  NodeModel getSourceNode(EdgeModel edge, List<NodeModel> nodes) {
    for (var node in nodes) {
      if (node.x == edge.x1 && node.y == edge.y1) {
        return node;
      }
    }
    throw Exception("No source node found for edge");
  }

  NodeModel getTargetNode(EdgeModel edge, List<NodeModel> nodes) {
    for (var node in nodes) {
      if (node.x == edge.x2 && node.y == edge.y2) {
        return node;
      }
    }
    throw Exception("No target node found for edge");
  }

}