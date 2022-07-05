import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/cart_model.dart';
import 'package:foodfair/models/order_model.dart';
import 'package:foodfair/models/user_model.dart';

import '../global/add_item_to_cart.dart';
import '../global/global_instance_or_variable.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  //fetch all sellers
  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>>?
  fetchAllSellers() async {
    Stream<QuerySnapshot<Map<String, dynamic>>>? queryData;
    try {
      queryData = _db
          .collection(
        "sellers",
      )
          .snapshots();
      return queryData;
    } catch (error) {
      throw "error";
    }
  }

  //fetch a specific seller menu with once's id
  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
  fetchSpecificSellerMenus(String sellerID) async {
    Stream<QuerySnapshot<Map<String, dynamic>>>? queryData;
    try {
      queryData = _db
          .collection("sellers")
          .doc(sellerID)
          .collection("menus")
          .orderBy("publishedDate", descending: true)
          .snapshots();
      return queryData;
    } catch (error) {
      throw "error";
    }
  }

  // fetch a specific seller items with id
  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
  fetchSpecificSellerItems(String sellerID, String menuID) async {
    Stream<QuerySnapshot<Map<String, dynamic>>>? queryData;
    try {
      queryData = _db
          .collection("sellers")
          .doc(sellerID)
          .collection("menus")
          .doc(menuID)
          .collection("items")
          .orderBy("publishedDate", descending: true)
          .snapshots();
      return queryData;
    } catch (error) {
      throw "error";
    }
  }

  //add user in firestore
  static Future<void> addUser(UserModel userModel, String userId) async {
    return _db.collection("users").doc(userId).set(userModel.toMap());
  }

  //add to cart
  static Future<void> addToCart(String userId, CartModel cartModel)async{
    print("userId = $userId");
    print("cartModel = ${cartModel.toString()}");
    try{
      return _db.collection("users").doc(userId).collection("cart")
          .doc(cartModel.itemID).set(cartModel.toMap());
    }catch(error){
      throw "error";
    }
  }

  //fetch cart list for specific user
  static Stream<QuerySnapshot<Map<String, dynamic>>>? fetchCartItemsForSpecificUser(String userId){
    try{
      return _db.collection("users").doc(userId).collection("cart").snapshots();
    }
    catch(erro){
      throw "error";
    }
  }

  //remove an item from cart
  static Future<void> removeFromCart(String ItemId, String userId)async{
    try{
      return _db.collection("users").doc(userId).collection('cart').doc(ItemId).delete();
    }catch(error){
      throw "error";
    }
  }

  //clear all cart items
  static Future<void> removeAllitemsFromCart(String userId, List<CartModel> cartModelList)async{
    //all product id wll assign into wb.delete collection then we will commit
    final wb = _db.batch();
    for(var cartModel in cartModelList){
      final cartDocumentId = _db.collection("users").doc(userId).collection("cart").
      doc(cartModel.itemID);
      //all product id wll assign into wb.delete collection then we will commit
      wb.delete(cartDocumentId);
    }
    return wb.commit();
  }

  //updating cart's quantity
  static Future<void> updateCartQuantity(CartModel cartModel, String userId) {
    return _db.collection("users").doc(userId).collection("cart")
        .doc(cartModel.itemID).update({"quantity": cartModel.quantity});
  }

  //add order
  static Future<void> addOrder(OrderModel orderModel, String orderId) async {
    await _db
        .collection("users")
        .doc(sPref!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(orderModel.toMap());

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(orderModel.toMap());
    return;
  }

  //fetch specific user's orders
  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>>?
  fetchOrders() async {
    Stream<QuerySnapshot<Map<String, dynamic>>>? queryData;
    try {
      //here we get the order list of order collection which are normal
      queryData = _db
          .collection("users")
          .doc(sPref!.getString("uid"))
          .collection("orders")
          .where("status", isEqualTo: "normal")
          .orderBy("orderTime", descending: true)
          .snapshots();
      return queryData;
    } catch (error) {
      throw "error";
    }
  }



// //fetch items those are ordered from a specific user
// static Future<QuerySnapshot<Map<String, dynamic>>> fetchOrderedItems(OrderModel orderModel) async {
//   QuerySnapshot<Map<String, dynamic>> queryData;
//   List<String> itemList = separatedItemIDFromOrdersCollection(orderModel.productIDs);
//   for(int i=0; i<itemList.length; i++){
//     print("itemId in db = ${itemList[i]}");
//   }
//   print('');
//   try {
//     queryData = await _db
//         .collection(
//             "items") /*insdie of items colleciton we will search which items are ordered.*/
//         .where("itemID",
//             /*if itemID is exist in separateOrdersItemsIDs*/
//             whereIn: itemList).
//         get();
//     print('dfd');
//         for(int i = 0; i< queryData.docs.length; i++){
//           print("after itemId = ${queryData.docs[i].id}");
//         }
//         print('');
//     return queryData;
//   } catch (error) {
//     throw "error";
//   }
// }
}