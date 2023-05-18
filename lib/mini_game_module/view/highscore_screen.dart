import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/game_model.dart';
import '../widget/app_drawrer.dart';

class HighScoreScreen extends StatelessWidget {
  static const routeName = '/high-score';

  const HighScoreScreen({super.key});

  Widget _highScoreItem(
      Text itemTitle, IconData leadinngIcon, Color itemColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        child: ListTile(
          tileColor: itemColor,
          contentPadding: const EdgeInsets.all(20.0),
          leading: Icon(
            leadinngIcon,
            size: 35,
            color: Colors.white,
          ),
          title: itemTitle,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'High Score',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _playerhighScoreGame =
        Provider.of<Game>(context).player?.highScoreGame;
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
              const SizedBox(
                height: 32.0,
              ),
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              const SizedBox(
                height: 32.0,
              ),
              _highScoreItem(
                Text(
                  'On ${DateFormat('dd/MM/yyyy').format(_playerhighScoreGame!.datePlayed)}',
                  style: const TextStyle(color: Colors.white),
                ),
                Icons.calendar_today_rounded,
                const Color.fromRGBO(224, 81, 98, 1),
              ),
              _highScoreItem(
                Text(
                  '${_playerhighScoreGame.numberOfCorrectAnswers} correct answers',
                  style: const TextStyle(color: Colors.white),
                ),
                Icons.check_circle_outline,
                const Color.fromRGBO(84, 160, 86, 1),
              ),
              _highScoreItem(
                Text(
                  '${_playerhighScoreGame.numberOfWrongAnswers} wrong answers',
                  style: const TextStyle(color: Colors.white),
                ),
                Icons.cancel_outlined,
                const Color.fromRGBO(68, 150, 224, 1),
              ),
              _highScoreItem(
                Text(
                  'score of ${_playerhighScoreGame.score}',
                  style: const TextStyle(color: Colors.white),
                ),
                Icons.emoji_events_outlined,
                const Color.fromRGBO(111, 64, 222, 1),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
