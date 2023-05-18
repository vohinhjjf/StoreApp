import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/game_model.dart';

class TimerQuestionScoreRow extends StatefulWidget {
  const TimerQuestionScoreRow({
    super.key,
  });

  @override
  State<TimerQuestionScoreRow> createState() => _TimerQuestionScoreRowState();
}

class _TimerQuestionScoreRowState extends State<TimerQuestionScoreRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 100,
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(255, 152, 0, 1),
                  boxShadow: const [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Consumer<Game>(
                  builder: (context, game, child) {
                    return Center(
                        child: Text(
                      '${game.timer}s',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ));
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 100,
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
                    return Center(
                        child: Text(
                      game.question,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ));
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 100,
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(3, 169, 244, 1),
                  boxShadow: const [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Consumer<Game>(
                  builder: (context, game, child) {
                    return Center(
                        child: Text(
                      game.score,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ));
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
