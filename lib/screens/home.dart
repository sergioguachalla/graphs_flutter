import 'package:flutter/material.dart';
import 'package:flutter_graphs/utils/dijkstra.dart';
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
  bool isMaximizing = false;
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
  Map<String, Map<String, int>> graph = {};
  List path = [];
  List<List<int>> adjacencyMatrix = [];

  Key stateKey = UniqueKey();
  late DijkstraUtil dijkstra = DijkstraUtil(graph);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        key: stateKey,
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
              onTapDown: (details) async {
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
                    Colors.black,
                  ));
                });
                await addEdgeWeight();
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
            ),
          if(mode == Mode.delete)
            GestureDetector(
              onTapDown: (details){
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInBounds(details.localPosition)) {
                      deleteEdges(nodes[i].text);
                      nodes.removeAt(i);
                      nodeLabels.removeAt(i);
                      break;
                    }
                  }
                });
              },
            ),
          if(mode == Mode.dijkstraSource)
            GestureDetector(
              onTapDown: (details){
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInBounds(details.localPosition)) {
                      sourceNode = nodes[i];
                      mode = Mode.dijkstraTarget;
                      break;
                    }
                  }
                });
              },
            ),
          if(mode == Mode.dijkstraTarget)
            GestureDetector(
              onTapDown: (details){
                for (int i = 0; i < nodes.length; i++) {
                  if (nodes[i].isInBounds(details.localPosition)) {
                    targetNode = nodes[i];
                    path =
                    isMaximizing ? dijkstra.findPath(graph, sourceNode!.text, targetNode!.text) : dijkstra.findPath(graph, sourceNode!.text, targetNode!.text);
                    adjacencyMatrix = dijkstra.adjacencyMatrix(nodeLabels, edgeConnections);
                    break;
                  }
                }
                setState(() {
                  changeColor(nodes, edges, path);
                  mode = Mode.nothing;
                });
              },
            ),
        ],
      ),
        bottomNavigationBar: BottomAppBar(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.add_box_outlined,
                    color: (mode == Mode.add) ? Colors.blue : Colors.black),
                onPressed: () {
                  setState(() {
                    mode = Mode.add;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.insert_link_outlined,
                    color: (mode == Mode.linkTarget || mode == Mode.linkSource) ? Colors.blue : Colors.black),
                onPressed: () {
                  setState(() {
                    mode = Mode.linkSource;
                    sourceNode = null;
                    targetNode = null;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_forever,
                    color: (mode == Mode.delete) ? Colors.blue : Colors.black),
                onPressed: () {
                  setState(() {
                    mode = Mode.delete;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.touch_app_outlined,
                    color: (mode == Mode.move) ? Colors.blue : Colors.black),

                onPressed: () {
                  setState(() {
                    mode = Mode.move;
                  });
                },
              ),
              PopupMenuButton(
                icon: Icon(Icons.calculate_outlined,
                    color: (mode == Mode.dijkstraTarget  || mode == Mode.dijkstraSource) ? Colors.blue : Colors.black),

                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Minimizar'),
                    onTap: () {
                      setState(() {
                        mode = Mode.dijkstraSource;
                        print('Minimizar');
                        isMaximizing = false;
                        print(isMaximizing);
                      });

                    },
                  ),
                  PopupMenuItem(
                    child: Text('Maximizar'),
                    onTap: () {
                      setState(() {
                        isMaximizing = true;
                        mode = Mode.dijkstraSource;
                        print('Maximizar');
                        print(isMaximizing);
                      });
                    },
                  ),
                ],
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

  Future<void> addEdgeWeight() async {
    await showDialog(context: context, builder: (context) {
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
                dijkstra.addConnection(sourceNode!.text, targetNode!.text, int.parse(weight));
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

  void addNodeName() {
    showDialog(context: context, builder: (context) {
      String enteredName = ''; // Variable para almacenar el nombre ingresado

      return AlertDialog(
        title: Text('Añadir nombre'),
        content: TextField(
          onChanged: (value) {
            enteredName = value; // Actualiza la variable cuando cambia el valor del TextField
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (enteredName.isNotEmpty) { // Verifica si el nombre no está vacío
                bool nameExists = nodes.any((node) => node.text == enteredName);
                if (!nameExists) { // Verifica si el nombre no existe en nodes
                  setState(() {
                    nodes.last = nodes.last.copyWith(text: enteredName);
                    nodeLabels.add(enteredName);
                    enteredName = '';
                    mode = Mode.nothing;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Muestra un mensaje de error si el nombre ya existe en nodes
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El nombre ya existe. Por favor, ingresa un nombre diferente.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              } else {
                // Muestra un mensaje de error si el nombre está vacío
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, ingresa un nombre válido.'),
                  ),
                );
              }
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
  deleteEdges(String nodeName) {
    List<int> indexes = [];
    for (int i = 0; i < edgeConnections.length; i++) {
      if (edgeConnections[i].source == nodeName ||
          edgeConnections[i].target == nodeName) {
        indexes.add(i);
      }
    }
    List<EdgeConnection> edgesConnectionsCopy = [];
    List<EdgeModel> edgesCopy = [];
    for (int i = 0; i < edgeConnections.length; i++) {
      if (!indexes.contains(i)) {
        edgesConnectionsCopy.add(edgeConnections[i]);
        edgesCopy.add(edges[i]);
      }
    }
    edgeConnections = edgesConnectionsCopy;
    edges = edgesCopy;

    // Eliminar conexiones del grafo
    graph.remove(nodeName);
    graph.forEach((key, innerMap) {
      innerMap.remove(nodeName);
    });
  }

  void changeColor(List<NodeModel>nodes, List<EdgeModel> edges, path ){
      for(int i = 0; i < nodes.length; i++){
        if(path.contains(nodes[i].text)){
          nodes[i] = nodes[i].copyWith(color: Colors.tealAccent);


        }
        else{
          nodes[i] = nodes[i].copyWith(color: Colors.indigoAccent);
        }

  }

      stateKey = UniqueKey();
  }



}
