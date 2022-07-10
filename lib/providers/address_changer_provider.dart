import 'package:flutter/material.dart';

class AddressChangerProvider with ChangeNotifier{
  int _radioButtonIndex = 0;
  int get  radioButtonIndex => _radioButtonIndex;

  void getRadioButtonIndex(dynamic newIndex){
      _radioButtonIndex = newIndex;
      notifyListeners();
  }
}