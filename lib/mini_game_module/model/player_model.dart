import 'package:flutter/material.dart';

class HighScoreGame {
  final int score;
  final int numberOfCorrectAnswers;
  final int numberOfWrongAnswers;
  final DateTime datePlayed;

  HighScoreGame(
      {required this.score,
      required this.numberOfCorrectAnswers,
      required this.numberOfWrongAnswers,
      required this.datePlayed});

  factory HighScoreGame.fromJson(Map<dynamic, dynamic> json) =>
      _HighScoreGameFromJson(json);

  Map<String, dynamic> toJson() => _HighScoreGameToJson(this);

  int get highScore {
    return this.score;
  }
}

HighScoreGame _HighScoreGameFromJson(Map<dynamic, dynamic> json) {
  return HighScoreGame(
      score: json['score'],
      numberOfCorrectAnswers: json['numberOfCorrectAnswers'],
      datePlayed: DateTime.parse(json['datePlayed']),
      numberOfWrongAnswers: json['numberOfWrongAnswers']);
}

Map<String, dynamic> _HighScoreGameToJson(HighScoreGame instance) =>
    <String, dynamic>{
      'score': instance.score,
      'numberOfCorrectAnswers': instance.numberOfCorrectAnswers,
      'datePlayed': instance.datePlayed.toIso8601String(),
      'numberOfWrongAnswers': instance.numberOfWrongAnswers,
    };

//1
Player _PlayerFromJson(Map<dynamic, dynamic> json) {
  return Player(
    uid: json['uid'],
    dateCreated: DateTime.parse(json['dateCreated']),
    gameOperation: json['gameOperation'],
    highScoreGame: _HighScoreGameFromJson(json['highScoreGame']),
  );
}

//2
Map<String, dynamic> _PlayerToJson(Player instance) => <String, dynamic>{
      'uid': instance.uid,
      'dateCreated': instance.dateCreated!.toIso8601String(),
      'gameOperation': instance.gameOperation,
      'highScoreGame': _HighScoreGameToJson(instance.highScoreGame!),
    };

class Player with ChangeNotifier {
  final String? uid;
  final DateTime? dateCreated;
  final String? gameOperation;
  HighScoreGame? highScoreGame;

  Player(
      { this.uid,
       this.dateCreated,
       this.gameOperation,
       this.highScoreGame});

  factory Player.fromJson(Map<dynamic, dynamic> json) => _PlayerFromJson(json);

  // 5
  Map<String, dynamic> toJson() => _PlayerToJson(this);

  // ignore: non_constant_identifier_names
  HighScoreGame get player_highScoreGame {
    return highScoreGame!;
  }
}
