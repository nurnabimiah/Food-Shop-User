import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import '../db/db_helper.dart';
import '../global/global_instance_or_variable.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _cartModelList = [];

  List<CartModel> get cartModelList => _cartModelList;

  Future<void> addToCart(ItemModel itemModel, int quantity) async {
    final cartModel = CartModel(
      itemID: itemModel.itemID,
      itemTitle: itemModel.itemTitle,
      shortInformation: itemModel.shortInformation,
      itemImageUrl: itemModel.itemImageUrl,
      price: itemModel.price!,
      sellerId: itemModel.sellerUID,
      quantity: quantity,
    );
    await DbHelper.addToCart(sPref!.getString("uid")!, cartModel);
  }

  //fetch cart
  fetchCartItemsForSpecificUser() async {
    DbHelper.fetchCartItemsForSpecificUser(sPref!.getString("uid")!)!
        .listen((snapshot) {
      _cartModelList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
      //if at least one have one item in cart that's mean user have cart's item to order from
      // a specific restaurant(sellerId).
      //so user could not add to cart with multiple sellerId.
      if (_cartModelList.isNotEmpty) {
        previousSellerId = _cartModelList[0].sellerId!;
      }
      notifyListeners();
    });
  }

  //total length of cart
  int get totalItemsInCart => _cartModelList.length;

  //total price for cart
  num get cartItemsTotalPrice {
    num total = 0;
    _cartModelList.forEach((item) {
      total += item.quantity * item.price!;
    });
    return total;
  }

  //is already in cart or not
  bool isAlreadyIncart(String itemId) {
    bool tag = false;
    for (var cart in _cartModelList) {
      if (cart.itemID == itemId) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  //remove from cart an item
  Future<void> removeFromCart(String itemId) async {
    DbHelper.removeFromCart(itemId, sPref!.getString("uid")!).then((value) {
      if (_cartModelList.isEmpty) {
        previousSellerId = '';
      }
    });
  }

  //increasing item quantity in firebase
  void increaseItemQuantityInFirebase(String itemId) {
    CartModel cartModel;
    //I need cartModel to update quantity in specific ItemModel with its itemId.
    //depending on cartModel many calculation have been done. like in cartScreen total
    //price etc. so here cartModel is necessary
    for (int i = 0; i < _cartModelList.length; i++) {
      if (_cartModelList[i].itemID == itemId) {
        cartModel = _cartModelList[i];
        cartModel.quantity += 1;
        DbHelper.updateCartQuantity(cartModel, sPref!.getString("uid")!);
        break;
      }
    }
  }

  //decreasing item quantity in firebase
  void decreaseItemQuantityInFirebase(String itemId) {
    CartModel cartModel;
    //I need cartModel to update quantity in specific ItemModel with its itemId
    for (int i = 0; i < _cartModelList.length; i++) {
      if (_cartModelList[i].itemID == itemId) {
        cartModel = _cartModelList[i];
        //I will not decrease if quantity 1
        cartModel.quantity > 1 ? cartModel.quantity -= 1 : cartModel.quantity;
        DbHelper.updateCartQuantity(cartModel, sPref!.getString("uid")!);
        break;
      }
    }
  }

  //find quantity for specific item in CartModel
  int findQuantityInCartModelWithThisId(String itemId){
    CartModel? cartModel;
    for (int i = 0; i < _cartModelList.length; i++) {
      if (_cartModelList[i].itemID == itemId) {
        cartModel = _cartModelList[i];
        break;
      }
    }
    return cartModel!.quantity;
  }

  //remove all cart's items from cart colleciton
  Future<void> clearCart()async{
    DbHelper.removeAllitemsFromCart(sPref!.getString("uid")!, _cartModelList).then((value){
      previousSellerId = '';
    });
  }
}
