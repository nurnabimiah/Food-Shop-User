import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import '../db/db_helper.dart';
import '../global/global_instance_or_variable.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartModelList = [];

  Future<void> addToCartLocalOrFirebase(ItemModel itemModel, int quantity) async {
    final cartModel = CartModel(
      itemID: itemModel.itemID,
      itemTitle: itemModel.itemTitle,
      shortInformation: itemModel.shortInformation,
      itemImageUrl: itemModel.itemImageUrl,
      price: itemModel.price!,
      sellerId: itemModel.sellerUID,
      quantity: quantity,
    );

    //if user is logged in then it will add in firebase else in local
    if(firebaseAuth.currentUser != null){
      await DbHelper.addToCart(sPref!.getString("uid")!, cartModel, cartModelList);
    }else{
      //add local cart when user has not logged in
      cartModelList.add(cartModel);
      itemCounter = 1;
      itemIdAndQuantity[1] = itemCounter.toString();
      itemIdAndQuantity[0] = '-1';
      notifyListeners();
    }
  }
  
  void addToCartInFirebaseAfterFirstLogin()async{
    await DbHelper.addToCartAfterFirstLogin(sPref!.getString("uid")!, cartModelList);
  }

  //fetch cart
  fetchCartItemsForSpecificUser() async {
    if(firebaseAuth.currentUser != null){
      DbHelper.fetchCartItemsForSpecificUser(sPref!.getString("uid")!)!
          .listen((snapshot) {
        cartModelList = List.generate(snapshot.docs.length,
                (index) => CartModel.fromMap(snapshot.docs[index].data()));
        //if at least one have one item in cart that's mean user have cart's item to order from
        // a specific restaurant(sellerId).
        //so user could not add to cart with multiple sellerId.
        if (cartModelList.isNotEmpty) {
          previousSellerId = cartModelList[0].sellerId!;
        }
        notifyListeners();
      });
    }
    else{
    }
  }

  //total length of cart
  int get totalItemsInCart => cartModelList.length;

  //total price for cart
  num get cartItemsTotalPrice {
    num total = 0;
    cartModelList.forEach((item) {
      total += item.quantity * item.price!;
    });
    return total;
  }

  //is already in cart or not
  bool isAlreadyIncart(String itemId) {
    bool tag = false;
    for (var cart in cartModelList) {
      if (cart.itemID == itemId) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  //remove from cart an item
   Future<void> removeFromCartInLocalOrFirebase(String itemId) async {
    CartModel? cartModel2;
     for(var cartModel in cartModelList){
       if(cartModel.itemID == itemId){
         cartModel2 = cartModel;
         break;
       }
     }

    if(sPref!.getString("uid") != null){
      cartModel2!.quantity = 1;
      itemIdAndQuantity[1] = cartModel2.quantity.toString();
      //itemIdAndQuantity[0] == '-1';
      itemCounter = 1;
      notifyListeners();
      DbHelper.removeFromCart(itemId, sPref!.getString("uid")!).then((value) {
        if (cartModelList.isEmpty) {
          previousSellerId = '';
        }
      });
    }else{
      cartModelList.remove(cartModel2);

      // for(var cartModel in cartModelList){
      //   if(cartModel.itemID == itemId){
      //     cartModelList.remove(cartModel);

          //after remove that particular item's quantity should be 1 and _itemCounter
          //which is stopped increasing or decreasing when item in cart so should have set 1 for
          // _itemCounter in increaseItemQuantityInLocalOrFirebase and decreaseItemQuantityInLocalOrFirebase
          // these two methods..but I set here
          //add this all are for locally
          cartModel2!.quantity = 1;
          itemIdAndQuantity[1] = cartModel2.quantity.toString();
          itemIdAndQuantity[0] = '-1';
          itemCounter = 1;
          notifyListeners();
      //     break;
      //   }
      // }
      if (cartModelList.isEmpty) {
        previousSellerId = '';
      }
    }
  }

  int doubleCheck = 0;
  //increasing item quantity in firebase
  void increaseItemQuantityInLocalOrFirebase(String itemId) {
    CartModel cartModel;
    //I need cartModel to update quantity in specific ItemModel with its itemId.
    //depending on cartModel many calculation have been done. like in cartScreen total
    //price etc. so here cartModel is necessary
    for (int i = 0; i < cartModelList.length; i++) {
      if (cartModelList[i].itemID == itemId) {
        doubleCheck = 0;
        cartModel = cartModelList[i];
        cartModel.quantity += 1;
        if(sPref!.getString("uid") != null){
          DbHelper.updateCartQuantity(cartModel, sPref!.getString("uid")!);
          break;
        }
        else{
          // to show after increasing value after add in cart
          //when we will add in cart then again we want to increase locally then this need
          itemIdAndQuantity[1] = cartModel.quantity.toString();
          notifyListeners();
          break;
        }
      }
    }
  }

  //decreasing item quantity in firebase
  void decreaseItemQuantityInLocalOrFirebase(String itemId) {
    CartModel cartModel;
    //I need cartModel to update quantity in specific ItemModel with its itemId
    for (int i = 0; i < cartModelList.length; i++) {
      if (cartModelList[i].itemID == itemId) {
        cartModel = cartModelList[i];
        doubleCheck = 0;
        //I will not decrease if quantity 1
        cartModel.quantity > 1 ? cartModel.quantity -= 1 : cartModel.quantity;
        if(sPref!.getString("uid") != null){
          DbHelper.updateCartQuantity(cartModel, sPref!.getString("uid")!);
          break;
        }
        else{
          // to show after decreasing value after add in cart
          //when we add in cart then again we want to decrease locally then this need
          itemIdAndQuantity[1] = cartModel.quantity.toString();
          notifyListeners();
          break;
        }
      }
    }
  }

  //find quantity for specific item in CartModel
  //this needs when item is already in cart
  int findQuantityInCartModelWithThisId(String itemId){
    CartModel? cartModel;
    for (int i = 0; i < cartModelList.length; i++) {
      if (cartModelList[i].itemID == itemId) {
        cartModel = cartModelList[i];
        break;
      }
    }
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   notifyListeners();
    // });
    return cartModel!.quantity;
  }

  //remove all cart's items from cart colleciton
  Future<void> clearCart()async{
    for(var cartModel in cartModelList){
      cartModel.quantity = 1;
      itemCounter = 1;
      itemIdAndQuantity[1] = 1.toString();
    }
    if(sPref!.getString("uid") != null){
      DbHelper.removeAllitemsFromCart(sPref!.getString("uid")!, cartModelList).then((value){
        previousSellerId = '';
      });
    }else{
      cartModelList.clear();
      previousSellerId = '';
      notifyListeners();
    }
  }

  //it needs a particular section from above code
  int itemCounter = 1;
  String? _itemId;
  String? get getterItemId => _itemId;
  //int get itemCounter => _itemCounter;
  List<String> itemIdAndQuantity = ["-1","-1"];

  //decrease items items locally before adding in cart
  void decreaseItemCounterBeforeAddInCart(String itemId){
    //locally decreasing for the first time item added in cart with addToCart method
    if(itemCounter == 1){
      return;
    }
    else{
      doubleCheck = 1;
      _itemId = itemId;
      //locally decreasing for the first time befor pressing add to cart
      //_indexAndQuantity[0] == this previous index
      if(itemIdAndQuantity[0] == itemId){
        itemCounter -= 1;
      }else{
        itemCounter = 1;
      }
      itemIdAndQuantity[0] = itemId;
      itemIdAndQuantity[1] = itemCounter.toString();
    }
    notifyListeners();
  }
  //increase items locally before adding in cart
  void increaseItemCounterBeforeAddInCart(String itemId){
    _itemId = itemId;
    doubleCheck = 1;
    //locally increasing for the first time befor pressing add to cart
    //_indexAndQuantity[0] == this previous index
    if(itemIdAndQuantity[0] == itemId || itemIdAndQuantity[0] == '-1'){
      itemCounter += 1;
    }
    else if(itemIdAndQuantity[0] != itemId){
      itemCounter = 1;
      itemCounter += 1;
    }
    itemIdAndQuantity[0] = itemId;
    itemIdAndQuantity[1] = itemCounter.toString();
    // _itemCounter = 1;
    notifyListeners();
  }
}
