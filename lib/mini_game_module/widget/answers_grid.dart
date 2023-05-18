import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/game_model.dart';
import 'answer_item.dart';

class AnswersGrid extends StatelessWidget {
  const AnswersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<Game>(context);
    final answers = gameData.answers;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: answers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          return AnswerItem(
            answer: answers[index],
            index: index,
          );
        });
  }
}
