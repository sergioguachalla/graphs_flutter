import 'package:dijkstra/dijkstra.dart';

import '../models/edge_connection.dart';

class DijkstraUtil {
  List<List> pairsList = [];
  late Map<String, double> distances;
  late Map<String, String?> predecessors;
  Map<String, Map<String, int>> graph = {};

  DijkstraUtil(this.graph);

  addPair(String source, String target) {
    pairsList.add([source, target]);
  }

  void addConnection(String source, String target, int weight) {
    // Asegurar que el source existe en el grafo y agregar/actualizar la conexión a target
    if (!graph.containsKey(source)) {
      graph[source] = {};
    }
    graph[source]![target] = weight;

    // Asegurar que el target existe en el grafo y agregar/actualizar la conexión a source
    if (!graph.containsKey(target)) {
      graph[target] = {};
    }
    graph[target]![source] = weight;
  }

  findPath(graph, from, to) {

    var path = Dijkstra.findPathFromGraph(graph, from, to);
    return path;
  }


  Map<String, Map<String, int>> setNegativeWeight(Map<String, Map<String, int>> graph) {
    Map<String, Map<String, int>> newGraph = {};
    graph.forEach((key, value) {
      newGraph[key] = {};
      value.forEach((key2, value2) {
        newGraph[key]![key2] = -value2;
      });
    });
    return newGraph;
  }
  List<List<int>> adjacencyMatrix(List<String> nodesNames, List<EdgeConnection> edgesConnections) {
    List<List<int>> adjacencyMatrix = List.generate(nodesNames.length + 1, (index) => List.filled(nodesNames.length + 1, 0));
    Map<String, int> nodeIndices = {};
    List<int> rowSums = List.filled(nodesNames.length, 0);
    List<int> colSums = List.filled(nodesNames.length, 0);

    for (int i = 0; i < nodesNames.length; i++) {
      nodeIndices[nodesNames[i]] = i;
    }
    if (edgesConnections.isNotEmpty) {
      for (var obj in edgesConnections) {
        int sourceIndex = nodeIndices[obj.source]!;
        int targetIndex = nodeIndices[obj.target]!;
        adjacencyMatrix[sourceIndex][targetIndex] = obj.cost;
        rowSums[sourceIndex] += obj.cost;
        colSums[targetIndex] += obj.cost;
      }
    }
    for (int i = 0; i < nodesNames.length; i++) {
      adjacencyMatrix[i][nodesNames.length] = rowSums[i];
      adjacencyMatrix[nodesNames.length][i] = colSums[i];
    }

    // for (int i = 0; i < adjacencyMatrix.length; i++) {
    //   print(adjacencyMatrix[i]);
    // }
    return adjacencyMatrix;
  }

  List<List<int>> dijkstraMax(List<List<int>> adjacencyMatrix, int startNode) {
    int n = adjacencyMatrix.length;
    List<int> dist = List.filled(n, 999999999);  // Valor alto como sustituto de Infinity
    List<bool> visited = List.filled(n, false);
    List<int> prev = List.filled(n, -1); // Para rastrear el nodo anterior en la ruta óptima
    List<List<int>> paths = List.generate(n, (index) => []);

    dist[startNode] = 0;

    for (int i = 0; i < n - 1; i++) {
      int u = -1;
      for (int j = 0; j < n; j++) {
        if (!visited[j] && (u == -1 || dist[j] < dist[u])) {
          u = j;
        }
      }
      visited[u] = true;
      for (int v = 0; v <  - 1; v++) {
        if (adjacencyMatrix[u][v] != 0 && !visited[v] && dist[u] + adjacencyMatrix[u][v] < dist[v]) {
          dist[v] = dist[u] + adjacencyMatrix[u][v];
          prev[v] = u; // Guardar u como el nodo anterior a v en la ruta óptima
        }
      }
    }

    // Construir las rutas usando el array prev
    for (int i = 0; i < n; i++) {
      int current = i;
      while (current != -1) {
        paths[i].insert(0, current); // Insertar al principio para mantener el orden
        current = prev[current];
      }
    }

    return paths;
  }

}


