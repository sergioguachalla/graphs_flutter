import 'package:flutter/material.dart';
import 'package:flutter_graphs/utils/modes.dart';

import '../widget_models/node_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const double radius = 30;
  Mode mode = Mode.nothing;
  List<NodeModel> nodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ...nodes,
          if (mode == Mode.add)
            GestureDetector(
              onTapDown: (position) {
                setState(
                      () {
                    if (isInsideScreen(position.localPosition.dx, position.localPosition.dy)) {

                      nodes.add(NodeModel(
                        Colors.indigoAccent,
                        position.localPosition.dx,
                        position.localPosition.dy,
                        radius,
                        '',
                      ));
                    }
                  },
                );
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
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () {
                setState(() {
                  mode = Mode.add;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.insert_link_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.touch_app_outlined),
              onPressed: () {},
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
}
