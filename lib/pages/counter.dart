import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:buddiesgram/models/score_model.dart';
class Counter extends StatelessWidget {
  final String teamName;

  Counter({Key key, this.teamName});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScoreModel>(
      builder: (context, child, model) => Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$teamName",
              style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,
              ),
            ),
            Text(
              model.score.toString(),
              style: TextStyle(
                fontSize: 128, fontWeight: FontWeight.bold, color: Colors.white,
              ),
            ),
            Column(
              children: <Widget>[
                FlatButton(
                  onPressed: model.increment2Score,
                  child: Text("+ 1", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  color: Colors.red,
                  splashColor: Colors.redAccent.shade50,
                  height: 80,
                ),
                FlatButton(
                  onPressed: model.increment3Score,
                  child: Text("+ 14", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  color: Colors.red.shade300,
                  splashColor: Colors.green,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}