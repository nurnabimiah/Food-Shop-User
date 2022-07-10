import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodfair/models/items_model.dart';
import '../db/db_helper.dart';
import '../global/global_instance_or_variable.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartModelList = [];

 // List<CartModel> get cartModelList => _cartModelList;
  //int get infiniteChecking => _infiniteChecking;

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

    if(sPref!.getString("uid") != ''){
      cartModel2!.quantity = 1;
      itemIdAndQuantity[1] = cartModel2.quantity.toString();
      _itemCounter = 1;
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
          _itemCounter = 1;
          notifyListeners();
      //     break;
      //   }
      // }
      if (cartModelList.isEmpty) {
        previousSellerId = '';
      }
    }
  }

  //increasing item quantity in firebase
  void increaseItemQuantityInLocalOrFirebase(String itemId) {
    CartModel cartModel;
    //I need cartModel to update quantity in specific ItemModel with its itemId.
    //depending on cartModel many calculation have been done. like in cartScreen total
    //price etc. so here cartModel is necessary
    for (int i = 0; i < cartModelList.length; i++) {
      if (cartModelList[i].itemID == itemId) {
        cartModel = cartModelList[i];
        cartModel.quantity += 1;
        if(sPref!.getString("uid") != ''){
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
        //I will not decrease if quantity 1
        cartModel.quantity > 1 ? cartModel.quantity -= 1 : cartModel.quantity;
        if(sPref!.getString("uid") != ''){
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
    print("findQuantityInCartModelWithThisId = 1");
    CartModel? cartModel;
    for (int i = 0; i < cartModelList.length; i++) {
      if (cartModelList[i].itemID == itemId) {
        print("findQuantityInCartModelWithThisId = 2");
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
      _itemCounter = 1;
      itemIdAndQuantity[1] = 1.toString();
    }
    if(sPref!.getString("uid") != ''){
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
  int _itemCounter = 1;
  List<String> itemIdAndQuantity = ["-1","-1"];

  //decrease items
  void decreaseItemCounterBeforeAddInCart(String itemId){
    //locally decreasing for the first time item added in cart with addToCart method
    if(_itemCounter == 1){}
    else{
      //locally decreasing for the first time befor pressing add to cart
      //_indexAndQuantity[0] == this previous index
      if(itemIdAndQuantity[0] == itemId){
        _itemCounter -= 1;
      }else{
        _itemCounter = 1;
        _itemCounter -= 1;
      }
      itemIdAndQuantity[0] = itemId;
      itemIdAndQuantity[1] = _itemCounter.toString();
    }
    notifyListeners();
  }
  //increase items
  void increaseItemCounterBeforeAddInCart(String itemId){

    //locally increasing for the first time befor pressing add to cart
    //_indexAndQuantity[0] == this previous index
    if(itemIdAndQuantity[0] == itemId){
      _itemCounter += 1;
    }else{
      _itemCounter = 1;
      _itemCounter += 1;
    }
    itemIdAndQuantity[0] = itemId;
    itemIdAndQuantity[1] = _itemCounter.toString();
    notifyListeners();
  }
  //if user increases itemCounter but not able to
  // add in cart then it is necessary.
  int get defaultItemQuanity{
    // _itemIdAndQuantity = ["-1", "-1"];
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   notifyListeners();
    // });
    return 1;
  }

  //just for rebuilding itemWidget
  int? _rebuild;
  int? get rebuild => _rebuild;
  void rebuildItemWidget(){
    //itemIdAndQuantity[0] = '-1';
    notifyListeners();
  }
}
