import 'package:flutter/foundation.dart';

class GhostStamina extends ChangeNotifier {
  int _ghostStamina;
  final int maxStamina;

  GhostStamina(this._ghostStamina, this.maxStamina);

  int get ghostStamina => _ghostStamina;

  void decrease(int amount) {
    _ghostStamina = (_ghostStamina - amount).clamp(0, maxStamina);
    notifyListeners();
  }

  void increase(int amount) {
    _ghostStamina = (_ghostStamina + amount).clamp(0, maxStamina);
    notifyListeners();
  }

  void reset(int currentStamina) {
    _ghostStamina = currentStamina;
    notifyListeners();
  }
}
