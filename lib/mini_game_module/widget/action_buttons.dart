import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/game_model.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _game = Provider.of<Game>(context);
    return SizedBox(
      height: 100,
      child: GestureDetector(
        onTap: () {
          _game.playTheGame();
        },
        child: Card(
          margin: const EdgeInsets.all(10),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.white, spreadRadius: 3),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Consumer<Game>(
              builder: (context, game, child) {
                return Image.asset(
                  _game.actionButtonImage,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
