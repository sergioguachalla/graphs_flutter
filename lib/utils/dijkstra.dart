import 'package:dijkstra/dijkstra.dart';

class Dijkstra{
  List<List> pairsList = [];

  Map<String, Map<String, int>> graph = {};


  addPair(String source, String target){
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




}