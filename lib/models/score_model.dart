import 'package:scoped_model/scoped_model.dart';
class ScoreModel extends Model {
  int _score = 0;

  int get score => _score;

  void increment3Score() {
    _score += 14;
    notifyListeners();
  }

  void increment2Score() {
    _score += 1;
    notifyListeners();
  }

  void decrement3Score() {
    _score -= 14;
    notifyListeners();
  }

  void decrement2Score() {
    _score -= 1;
    notifyListeners();
  }

  void reset() {
    _score = 0;
  }
}