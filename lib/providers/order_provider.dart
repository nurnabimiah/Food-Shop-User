import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodfair/db/db_helper.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/models/order_model.dart';

import '../global/global_instance_or_variable.dart';
import '../models/cart_model.dart';
import '../models/order_constants_model.dart';

class OrderProvider with ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _ordersData;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _itemsData;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get ordersData => _ordersData;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get itemsData => _itemsData;

  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> userOrderList = [];

  void getOrderConstants() async {
    DbHelper.fetchOrderConstants().listen((snapshot) {
      if(snapshot.exists){
        orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  //add order
  Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList) async {
    return DbHelper.addOrder(orderModel, cartList);
  }

  //fetch orders for specific user
  Future<void> fetchOrders() async {
    _ordersData = await DbHelper.fetchOrders(sPref!.getString("uid")!);
    notifyListeners();
  }

  //fetch a specific user's orderDetails
 Stream<QuerySnapshot<Map<String, dynamic>>> fetchItemsOfOrderDetails(String orderId) {
      _itemsData =  DbHelper.fetchItemsOfOrderDetails(orderId, sPref!.getString("uid")!);
      return _itemsData!;
  }

}