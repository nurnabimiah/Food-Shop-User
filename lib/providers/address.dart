import 'package:flutter/widgets.dart';

class AddressProvider with ChangeNotifier {
  int _counter = 0;
  int get count => _counter;
  displayResult(dynamic newValue) {
    _counter = newValue;
    notifyListeners();
  }
}
