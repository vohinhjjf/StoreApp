import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/operation_model.dart';
import 'config_item.dart';

class ConfigGrid extends StatefulWidget {
  const ConfigGrid({super.key});

  @override
  State<ConfigGrid> createState() => _ConfigGridState();
}

class _ConfigGridState extends State<ConfigGrid> {
  final List<String> myList = ['+', 'x', '/', '-', '?'];

  final List<Operation> _operations = [
    Operation('+', 'Addition'),
    Operation('-', 'Substraction'),
    Operation('x', 'Multiplication'),
    Operation('÷', 'Division'),
    Operation('?', 'Random')
  ];

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: _operations.length,
      itemBuilder: (BuildContext context, int index) {
        return ConfigItem(
          operation: _operations[4],
          index: index,
        );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(index == _operations.length - 1 ? 2 : 1, 1),
    );

/*     GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _operations.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          return ConfigItem(
            operation: _operations[index],
            index: index,
          );
        }); */
  }
}
