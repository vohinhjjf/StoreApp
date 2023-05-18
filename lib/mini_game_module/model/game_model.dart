import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/data_repository.dart';
import 'player_model.dart';

class Answer with ChangeNotifier {
  final int value;

  Answer(this.value);
}

class Game with ChangeNotifier {
  late String operation;
  late int _correctAnswerIndex;
  int a = 0;
  int b = 0;
  int _numberOfCorrectAnswers = 0;
  int _numberOfQuestions = 0;
  bool isActive = false;
  int _score = 0;
  int _highScore = 0;
  Timer? _timer;
  int _countdown = 30;
  String _actionButtonImage = 'assets/images/play.png';
  String _mathOperation = '?';
  bool _gameOver = false;
  Player? _gamePlayer;
  final DataRepository repository = DataRepository();
  String earnPoint = '';

  List<Answer> _answers = [Answer(1), Answer(2), Answer(3), Answer(4)];

  List<Answer> get answers {
    // return [..._answers];
    return _answers;
  }

  Game(this.operation) {
    setupPlayer();
  }

  Player? get player {
    return _gamePlayer;
  }

  String get timer {
    // print(_countdown);
    return _countdown.toString();
  }

  String get actionButtonImage {
    // print(_actionButtonImage);
    return _actionButtonImage;
  }

  String get question {
    //print(_actionButtonImage);
    return '$a $_mathOperation $b';
  }

  String get completionMsg {
    var wrongAnswers = _numberOfQuestions == 0
        ? 0
        : (_numberOfQuestions - _numberOfCorrectAnswers);
    var scorePercentage = _numberOfQuestions == 0
        ? 0
        : (_score / _numberOfQuestions).toStringAsFixed(2);

    return 'Số điểm $_score \nCâu trả lời đúng : $_numberOfCorrectAnswers \nCâu trả lời sai: $wrongAnswers \nĐô chính xác $scorePercentage% \n$earnPoint';
  }

  bool get gameOver {
    return _gameOver;
  }

  String get score {
    return '$_score';
  }

  String get highScore {
    return '$_highScore';
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown < 1) {
        // print('Timer is done');
        isActive = false;
        _actionButtonImage = 'assets/images/playagain.png';
        timer.cancel();
        _gameOver = true;
        if (_score > _highScore) {
          _highScore = _score;
          _gamePlayer?.highScoreGame = HighScoreGame(
              datePlayed: DateTime.now(),
              numberOfWrongAnswers:
                  (_numberOfQuestions - _numberOfCorrectAnswers),
              numberOfCorrectAnswers: _numberOfCorrectAnswers,
              score: _highScore);

          repository.updatePlayer(_gamePlayer!);
        }
        if (_score > 100) {
          repository.addRedeemPoint(50);
          earnPoint = 'Bạn nhận được 50 kim cương';
        }
        notifyListeners();
      } else {
        _countdown = _countdown - 1;
        notifyListeners();
        //  print(_countdown);
      }
    });
  }

  void restartTheGame(String operation) {
    isActive = false;
    this.operation = operation;
    _timer?.cancel();
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    playTheGame();
  }

  void playTheGame() {
    if (!isActive) {
      //  print('Start Timer');
      _countdown = 30;
      _gameOver = false;
      _numberOfQuestions = 0;
      _score = 0;
      _numberOfCorrectAnswers = 0;
      _actionButtonImage = 'assets/images/question.png';
      setupGameRound();
      startTimer();
      isActive = true;
      notifyListeners();
    }
  }

  void setupGameRound() {
    int i11;
    int i12;
    _mathOperation = operation;
    if (true) {
      var list = ["+", "-", "x"];
      Random r = Random();
      _mathOperation = list[r.nextInt(list.length)];
    }
    Random rand = Random();
    if (_mathOperation.toLowerCase() == ("/").toLowerCase()) {
      i11 = rand.nextInt(14) + 1;
      i12 = rand.nextInt(6);
      if (i12 != 0) {
        b = i12 + 1;
        a = i11 * b;
      } else {
        a = i12 + 1;
        b = i11 * b;
      }
    } else if (_mathOperation.toLowerCase() == ("-").toLowerCase()) {
      i11 = rand.nextInt(21) + 1;
      i12 = rand.nextInt(21);
      int i20 = i12 + 1;
      if (i11 > i20) {
        a = i11;
        b = i20;
      } else {
        a = i20;
        b = i11;
      }
    } else {
      a = rand.nextInt(21);
      b = rand.nextInt(21);
    }
    _correctAnswerIndex = rand.nextInt(4);

    answers.clear();
    for (int i = 0; i < 4; i++) {
      if (i == _correctAnswerIndex) {
        answers.add(Answer(doMath(a, b, _mathOperation)));
      } else {
        int wrongAnswer = getRandom(a, b, _mathOperation);
        while (wrongAnswer == doMath(a, b, _mathOperation)) {
          wrongAnswer = getRandom(a, b, _mathOperation);
        }
        answers.add(Answer(wrongAnswer));
      }
    }

    _answers = answers;
    notifyListeners();
  }

  int getRandom(int a, int b, String sOperation) {
    int result = 41;

    Random rand = Random();
    if (sOperation.toLowerCase() == ("+").toLowerCase()) {
      result = rand.nextInt(41);
    } else if (sOperation.toLowerCase() == ("-").toLowerCase()) {
      result = rand.nextInt(41 + 20) - 20;
    } else if (sOperation.toLowerCase() == ("x").toLowerCase()) {
      if (a == 0) {
        a = 1;
      }
      if (b == 0) {
        b = 1;
      }
      result = rand.nextInt(2 * a * b);
    } else if (sOperation.toLowerCase() == ("÷").toLowerCase()) {
      result = rand.nextInt(41);
    }
    return result;
  }

  int doMath(int a, int b, String sOperation) {
    int result = 0;
    if (sOperation.toLowerCase() == ("+").toLowerCase()) {
      result = a + b;
    } else if (sOperation.toLowerCase() == ("-").toLowerCase()) {
      result = a - b;
    } else if (sOperation.toLowerCase() == ("x").toLowerCase()) {
      result = a * b;
    } else if (sOperation.toLowerCase() == ("÷").toLowerCase()) {
      result = (a / b).round();
    }
    return result;
  }

  void answerSelected(Answer answer) {
    if (isActive) {
      _numberOfQuestions = _numberOfQuestions + 1;
      // print(answer.value);
      verifyAnswer(answer);
      setupGameRound();

      notifyListeners();
    }
  }

  void verifyAnswer(Answer answer) {
    if (answer.value == _answers[_correctAnswerIndex].value) {
      _actionButtonImage = 'assets/images/correct.png';
      _numberOfCorrectAnswers = _numberOfCorrectAnswers + 1;
      _score += 100;
      notifyListeners();
    } else {
      _actionButtonImage = 'assets/images/wrong.png';
      notifyListeners();
    }
  }

  Future<void> setupPlayer() async {
    _gamePlayer =
        (await repository.getPlayer(FirebaseAuth.instance.currentUser!.uid))!;

    if (_gamePlayer == null) {
      _gamePlayer = Player(
          uid: FirebaseAuth.instance.currentUser!.uid,
          dateCreated: DateTime.now(),
          gameOperation: '+',
          highScoreGame: HighScoreGame(
              datePlayed: DateTime.now(),
              numberOfWrongAnswers: 0,
              numberOfCorrectAnswers: 0,
              score: 0));

      repository.addPlayer(_gamePlayer!);
    } else {
      print('Found it');

      _highScore = _gamePlayer!.highScoreGame!.score;
    }
  }
}
