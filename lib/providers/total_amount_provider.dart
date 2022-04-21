import 'package:flutter/widgets.dart';

class TotalAmountProvider with ChangeNotifier {
  double _amount = 0;
  double get TotalAmount => _amount;

  displayTotalAmount(double number) async{
    _amount = number;
    notifyListeners();
  }
}
