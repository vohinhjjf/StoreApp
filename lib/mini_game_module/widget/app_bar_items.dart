import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/game_model.dart';

// ignore: constant_identifier_names
enum FilterOptions { Addition, Random }

class AppBarItems extends StatefulWidget {
  const AppBarItems({super.key});

  @override
  State<AppBarItems> createState() => _AppBarItemsState();
}

class _AppBarItemsState extends State<AppBarItems> {
  FilterOptions _character = FilterOptions.Addition;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Game>(context).operation.toLowerCase() ==
        "Random".toLowerCase()) {
      _character = FilterOptions.Random;
    } else {
      _character = FilterOptions.Addition;
    }

    return Column(
      children: [
        ListTile(
          title: const Text('Addition'),
          leading: Radio<FilterOptions>(
            value: FilterOptions.Addition,
            groupValue: _character,
            onChanged: (FilterOptions? value) {
              setState(() {
                // print(value);
                Provider.of<Game>(context, listen: false).restartTheGame('+');
                _character = value!;
                Navigator.pop(context);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Random'),
          leading: Radio<FilterOptions>(
            value: FilterOptions.Random,
            groupValue: _character,
            onChanged: (FilterOptions? value) {
              setState(() {
                // print(value);
                Provider.of<Game>(context, listen: false)
                    .restartTheGame('Random');
                _character = value!;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }
}
