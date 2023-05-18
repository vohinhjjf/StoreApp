import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/game_model.dart';

class AnswerItem extends StatelessWidget {
  final Answer answer;
  final int index;

  static const _answercolot = [
    Color.fromRGBO(224, 81, 98, 1),
    Color.fromRGBO(84, 160, 86, 1),
    Color.fromRGBO(68, 150, 224, 1),
    Color.fromRGBO(111, 64, 222, 1),
  ];

  const AnswerItem({super.key, required this.answer, required this.index});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _game = Provider.of<Game>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            _game.answerSelected(answer);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _answercolot[index],
              boxShadow: const [
                BoxShadow(color: Colors.white, spreadRadius: 3),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Text(
              answer.value.toString(),
              style: const TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}
