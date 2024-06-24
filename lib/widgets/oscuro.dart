import 'package:flutter/material.dart';

class ModoNocturnoProvider extends ChangeNotifier {
  bool _modoNocturno = false;

  bool get modoNocturno => _modoNocturno;

  void toggleModoNocturno() {
    _modoNocturno = !_modoNocturno;
    notifyListeners();
  }
}
