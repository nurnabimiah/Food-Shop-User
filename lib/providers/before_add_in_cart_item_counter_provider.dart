// import 'package:flutter/material.dart';
//
// class BeforeAddInCardItemCounterProvider with ChangeNotifier{
//   // int _itemCounter = 1;
//   // List<String> itemIdAndQuantity = ["-1","-1"];
//   //
//   // //decrease items
//   // void decreaseItemCounterBeforeAddInCart(String itemId){
//   //   //locally decreasing for the first time item added in cart with addToCart method
//   //   if(_itemCounter == 1){}
//   //   else{
//   //     //locally decreasing for the first time befor pressing add to cart
//   //     //_indexAndQuantity[0] == this previous index
//   //     if(itemIdAndQuantity[0] == itemId){
//   //       _itemCounter -= 1;
//   //     }else{
//   //       _itemCounter = 1;
//   //       _itemCounter -= 1;
//   //     }
//   //     itemIdAndQuantity[0] = itemId;
//   //     itemIdAndQuantity[1] = _itemCounter.toString();
//   //   }
//   //   notifyListeners();
//   // }
//   // //increase items
//   // void increaseItemCounterBeforeAddInCart(String itemId){
//   //
//   //   //locally increasing for the first time befor pressing add to cart
//   //   //_indexAndQuantity[0] == this previous index
//   //   if(itemIdAndQuantity[0] == itemId){
//   //     _itemCounter += 1;
//   //   }else{
//   //     _itemCounter = 1;
//   //     _itemCounter += 1;
//   //   }
//   //   itemIdAndQuantity[0] = itemId;
//   //   itemIdAndQuantity[1] = _itemCounter.toString();
//   //   notifyListeners();
//   // }
//   // //if user increases itemCounter but not able to
//   // // add in cart then it is necessary.
//   // int get defaultItemQuanity{
//   //   // _itemIdAndQuantity = ["-1", "-1"];
//   //   // WidgetsBinding.instance.addPostFrameCallback((_){
//   //   //   notifyListeners();
//   //   // });
//   //   return 1;
//   // }
// }