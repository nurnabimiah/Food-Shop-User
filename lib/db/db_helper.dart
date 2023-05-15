 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodfair/models/address_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

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
  static Future<void> addToCart(
      String userId, CartModel cartModel, List<CartModel> cartModelList) async {
    try {
      return _db
          .collection("users")
          .doc(userId)
          .collection("cart")
          .doc(cartModel.itemID)
          .set(cartModel.toMap());
    } catch (error) {
      throw "error";
    }
  }

  //
  static Future<void> addToCartAfterFirstLogin(String userId, List<CartModel> cartModelList) async {
    try {
        final wb = _db.batch();
        for (var cartModel in cartModelList) {
          //cartDocumentId = here all itemId are assigned in cartDocumentId one by one
          final cartDocumentId = _db.collection("users").doc(userId).collection("cart").doc(cartModel.itemID);
          wb.set(cartDocumentId /*document*/, cartModel.toMap() /*data*/);
        }
        return wb.commit();
    } catch (error) {
      throw "error";
    }
  }

  //fetch cart list for specific user
  static Stream<QuerySnapshot<Map<String, dynamic>>>?
      fetchCartItemsForSpecificUser(String userId) {
    try {
      return _db.collection("users").doc(userId).collection("cart").snapshots();
    } catch (erro) {
      throw "error";
    }
  }

  //remove an item from cart
  static Future<void> removeFromCart(String ItemId, String userId) async {
    try {
      return _db
          .collection("users")
          .doc(userId)
          .collection('cart')
          .doc(ItemId)
          .delete();
    } catch (error) {
      throw "error";
    }
  }

  //clear all cart items
  static Future<void> removeAllitemsFromCart(
      String userId, List<CartModel> cartModelList) async {
    //all product id wll assign into wb.delete collection then we will commit
    final wb = _db.batch();
    for (var cartModel in cartModelList) {
      final cartDocumentId = _db
          .collection("users")
          .doc(userId)
          .collection("cart")
          .doc(cartModel.itemID);
      //all product id wll assign into wb.delete collection then we will commit
      wb.delete(cartDocumentId);
    }
    return wb.commit();
  }

  //updating cart's quantity
  static Future<void> updateCartQuantity(CartModel cartModel, String userId) {
    return _db
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(cartModel.itemID)
        .update({"quantity": cartModel.quantity});
  }

  //fetching orderConstant
  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchOrderConstants() =>
      _db.collection("orderUtils").doc("constant").snapshots();
  
  //add address
  static Future<void> addAddress(String userId, AddressModel addressModel)async{
    try{
          _db.collection("users")
          .doc(userId)
          .collection("userAddress")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(addressModel.toMap());
    }catch(error){
      throw "error";
    }
  }
  //fetch use all addresses
  static /*Future<*/Stream<QuerySnapshot<Map<String, dynamic>>>/*>*/ fetchUserAllAddress(String userId){
    Stream<QuerySnapshot<Map<String, dynamic>>>? queryData;
    try{
      queryData = _db.collection("users").doc(userId).collection("userAddress").snapshots();
      return queryData;
    }catch(error){
      throw "error";
    }
  }

  
  //add order
  static Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList) {
    final wb = _db.batch();
    //creating a new empty document for batch operation
    final orderDoc = _db.collection("orders").doc();
    orderModel.orderId = orderDoc.id;
    //orderModel is assigned this orderDoc(this id)
    wb.set(orderDoc, orderModel.toMap());

    for(var cart in cartList){
      //here inside of doc we put ProductModel one by one from cartList
      final docId = orderDoc.collection("orderDetails").doc(cart.itemID);
      wb.set(docId/*Document*/, cart.toMap()/*data*/);
    }
    return wb.commit();
  }

  //fetch specific user's orders
  static Stream<QuerySnapshot<Map<String, dynamic>>>?
      fetchOrders(String userId)  {
    Stream<QuerySnapshot<Map<String, dynamic>>>? queryData;
    try {
      //here we get the order list of order collection which are normal
      queryData = _db
          .collection("orders")
          .where("userId", isEqualTo: userId)
          .where("status", isEqualTo: "normal")
          .orderBy("orderTime", descending: true)
          .snapshots();
      return queryData;
    } catch (error) {
      throw "error";
    }
  }

  //fetch specific user's all Items Of OrderDetails
  static /*Future<*/Stream<QuerySnapshot<Map<String, dynamic>>>/*>*/?
  fetchItemsOfOrderDetails(String orderId, String userId){
    Stream<QuerySnapshot<Map<String, dynamic>>>? queryData;
    try {
      //here we get the order list of order collection which are normal
      queryData = _db
          .collection("orders").doc(orderId).collection("orderDetails")
          .snapshots();
      return queryData;
    } catch (error) {
      throw "error";
    }
  }
}
