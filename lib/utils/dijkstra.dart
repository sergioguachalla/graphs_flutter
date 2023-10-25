import 'package:dijkstra/dijkstra.dart';

class DijkstraUtil{
  List<List> pairsList = [];

  Map graph = {};


  DijkstraUtil(this.graph);

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

  findPath(graph,from, to){
    var path = Dijkstra.findPathFromGraph(graph, from, to);
    return path;
  }
  findMaxPath(graphD,from, to){
    setNegativeWeight(graphD);
    //var path = Dijkstra.findPathFromGraph(graph, from, to);
    print(graphD);
  }
  setNegativeWeight(graph){
    return graph.forEach((key, innerMap) {
      innerMap.forEach((innerKey, value) {
        innerMap[innerKey] = value * -1;
      });
    });
  }






}