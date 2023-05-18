import 'package:flutter/material.dart';

import '../widget/app_drawrer.dart';
import '../widget/config_grid.dart';

class OperationsScreen extends StatelessWidget {
  static const routeName = '/operation-config';

  const OperationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // final _game = context.watch<Game>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('BrainTrainer'),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                //leading: Icon(Icons.games_rounded),
                title: const Text(
                  'Select a math operation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),

                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OperationsScreen.routeName);
                },
              ), //Cen
              const Divider(),
              const Expanded(child: ConfigGrid()),
            ],
          ),
        ]),
      ),
    );
  }
}
