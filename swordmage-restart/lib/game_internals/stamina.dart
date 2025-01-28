import 'package:flutter/foundation.dart';

class Stamina extends ChangeNotifier {
  int _stamina;

  Stamina(this._stamina);

  int get stamina => _stamina;

  void decrease(int amount) {
    _stamina -= amount;
    notifyListeners();
  }

  void increase(int amount) {
    _stamina += amount;
    notifyListeners();
  }

  void reset() {
    _stamina = 10;
    notifyListeners();
  }
}
