import 'package:flutter/material.dart';

class ItemCounter{
  int _itemCounter = 1;

  int get itemCounter => _itemCounter;

  //decrease items
  void decreaseItemCounter(){
    //locally decreasing for the first time item added in cart with addToCart method
    if(_itemCounter == 1){}
    else{
      _itemCounter -= 1;
      print("decrease itemcoutner = $_itemCounter");
    }
  }
  //increase items
  void increaseItemCounter(){
    //locally increasing for the first time item added in cart with addToCart method
    _itemCounter += 1;
    print("increase itemcoutner = $_itemCounter");
  }
  //if user increases itemCounter but not able to
  // add in cart then it is necessary.
  void setItemCounterOne(){
    print("I an min setItemCounter");
    _itemCounter = 1;
  }
}