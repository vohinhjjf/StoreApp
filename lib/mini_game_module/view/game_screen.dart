import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/game_model.dart';
import '../widget/action_buttons.dart';
import '../widget/answers_grid.dart';
import '../widget/app_drawrer.dart';
import '../widget/game_confetti.dart';
import '../widget/timer_question_score.dart';

class GameScreen extends StatelessWidget {
  static const routeName = '/play-game';
  final User? user = FirebaseAuth.instance.currentUser;

  GameScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _game = context.watch<Game>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: user != null ? getPoint() : const Text('Mini Game'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  color: Colors.white,
                ),
                Text(
                  _game.highScore,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset('assets/images/game_background.jpg').image),
          color: Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                TimerQuestionScoreRow(),
                Expanded(child: AnswersGrid()),
                ActionButtons(),
              ],
            ),
            (_game.gameOver) ? const GameConfetti() : Container(),
          ]),
        ),
      ),
    );
  }

  getPoint() {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('Users').doc(user?.uid).get(),
        builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.hasData){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!['redeemPoint'].toString(),
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
                const Icon(Icons.diamond, color: Colors.blue),
              ],
            );
          }
          else if (snapshot.hasError) {
            return const Text(
              '0',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
