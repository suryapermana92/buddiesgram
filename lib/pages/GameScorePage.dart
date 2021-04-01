import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:buddiesgram/models/score_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:buddiesgram/pages/counter.dart';

class GameScorePage extends StatelessWidget {
//  @override
//  _GameScorePageState createState() => _GameScorePageState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Board',
      //theme: ThemeData.dark(),
      home: ScopedModel<ScoreModel>(
        model: ScoreModel(),
        child: ScoreCard(),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final ScoreModel teamAScoreModel = ScoreModel();
  final ScoreModel teamBScoreModel = ScoreModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Score Boarding", style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ScopedModel<ScoreModel>(
              model: teamAScoreModel,
              child: Counter(
                teamName: "Spieler A",
              ),
            ),
            Container(
              width: 2.0,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(color: Colors.white),
            ),
            ScopedModel<ScoreModel>(
              model: teamBScoreModel,
              child: Counter(
                teamName: 'Spieler B',
              ),
            ),
          ],
        ),
      ),
    );
  }
}