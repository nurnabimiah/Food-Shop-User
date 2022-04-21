import 'package:flutter/material.dart';
import 'package:foodfair/global/global_instance_or_variable.dart';
import 'package:provider/provider.dart';

class CartItemQuanityProvider extends ChangeNotifier {
  //total number of item of useCartList
  // here -1 is for ignoring garbase value in 0th index
  int _cartListitemQuanity = sPref!.getStringList("userCart")!.length - 1;

  int get itemQuantity => _cartListitemQuanity;
  //notifyListeners();
  Future<void> displayCartItemNumber() async {
    _cartListitemQuanity = sPref!.getStringList("userCart")!.length - 1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
 }
  // int get displayCartItemNumber => _cartListitemQuanity = sPref!.getStringList("userCart")!.length - 1;
  // notifyListeners();
}
