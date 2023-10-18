import 'package:flutter/material.dart';
import 'package:flutter_graphs/utils/modes.dart';

import '../models/edge_connection.dart';
import '../widget_models/edge_model.dart';
import '../widget_models/node_model.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String initialValue = '';
  static const double radius = 30;
  Mode mode = Mode.nothing;
  List<NodeModel> nodes = [];
  List<String> nodeLabels = [];
  List<EdgeModel> edges = [];
  List<EdgeConnection> edgeConnections = [];
  NodeModel? sourceNode;
  NodeModel? targetNode;
  String weight = '';
  int index = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ...edges,
          ...nodes,
          if (mode == Mode.add)
            GestureDetector(
              onTapDown: (position) {
                setState(() {
                  if (isInsideScreen(position.localPosition.dx,
                      position.localPosition.dy)) {
                    nodes.add(NodeModel(
                      Colors.indigoAccent,
                      position.localPosition.dx,
                      position.localPosition.dy,
                      radius,
                      '',
                    ));
                    addNodeName();
                  }
                });
              },
            ),
          if (mode == Mode.linkSource)
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInBounds(details.localPosition)) {
                      sourceNode = nodes[i];
                      break;
                    }
                  }
                  mode = Mode.linkTarget;
                });

              },
            ),
          if(mode == Mode.linkTarget)
            GestureDetector(
              onTapDown: (details){
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInBounds(details.localPosition)) {
                      targetNode = nodes[i];
                      break;
                    }
                  }
                  edges.add(EdgeModel(
                    sourceNode!.x,
                    sourceNode!.y,
                    targetNode!.x,
                    targetNode!.y,
                    radius,
                    '',
                  ));
                  addEdgeWeight();
                });

              }
            ),
          if(mode == Mode.move)
            GestureDetector(
              onPanDown: (details){
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInBounds(details.localPosition)) {
                      index = i;
                      break;
                    }
                  }
                });
              },
              onPanUpdate: (details){
                setState((){
                  if(isInsideScreen(details.localPosition.dx, details.localPosition.dy)){
                    nodes[index] = nodes[index].copyWith(x: details.localPosition.dx, y: details.localPosition.dy);
                    updateConnections();
                  }
                });
              },
              onPanEnd: (details){
                setState(() {
                  index = -1;
                });
              },
            )

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () {
                setState(() {
                  mode = Mode.add;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.insert_link_outlined),
              onPressed: () {
                setState(() {
                  mode = Mode.linkSource;
                  sourceNode = null;
                  targetNode = null;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.touch_app_outlined),
              onPressed: () {
                setState(() {
                  mode = Mode.move;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.calculate_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

  }

  bool isInsideScreen(double x, double y) {
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;
    final bottomPadding = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;
    if (x - radius > 0 &&
        x + radius < MediaQuery.of(context).size.width &&
        y - radius > 0 &&
        y + radius < MediaQuery.of(context).size.height - topPadding - bottomPadding - radius / 2) {
      return true;
    }
    return false;
  }

  void addEdgeWeight(){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Añadir peso'),
        content: TextField(
          onChanged: (value) {
            weight = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                edgeConnections.add(EdgeConnection(source: sourceNode!.text, target:targetNode!.text,cost: int.parse(weight)));
                edges.last = edges.last.copyWith(weight: weight);
                sourceNode = null;
                targetNode = null;
                mode = Mode.nothing;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Añadir'),
          ),
        ],
      );
    });
  }

  void addNodeName(){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Añadir nombre'),
        content: TextField(
          onChanged: (value) {
            initialValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                nodes.last = nodes.last.copyWith(text: initialValue);
                nodeLabels.add(initialValue);
                initialValue = '';
                mode = Mode.nothing;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Añadir'),
          ),
        ],
      );
    });
  }

  AlertDialog showAlertDialog(
      BuildContext context, {
        required String title,
        required Widget content,
        List<Widget> actions = const [],
      }) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    );
  }
  void updateConnections() {
    String nodeName = nodeLabels[index];
    List<int> indexes = [];
    for (int i = 0; i < edgeConnections.length; i++) {
      if (edgeConnections[i].source == nodeName || edgeConnections[i].target == nodeName) {
        indexes.add(i);
      }
    }
    for (int i = 0; i < edges.length; i++) {
      if (indexes.contains(i)) {
        if (edgeConnections[i].source == nodeName) {
          edges[i] = edges[i].copyWith(
            x1: nodes[index].x,
            y1: nodes[index].y,
          );
        } else {
          edges[i] = edges[i].copyWith(
            x2: nodes[index].x,
            y2: nodes[index].y,
          );
        }
      }
    }
  }

}
