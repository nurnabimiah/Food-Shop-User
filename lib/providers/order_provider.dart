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
  Future<QuerySnapshot<Map<String, dynamic>>>? _itemsData;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get ordersData => _ordersData;
  Future<QuerySnapshot<Map<String, dynamic>>>? get itemsData=> _itemsData;
  List<ItemModel> itemModelList =  [];
  // List<ItemModel> get itemModelList => _itemModelList;
  // List<ItemModel> get itemModelList {
  //   //print('object2');
  //   return _itemModelList;
  // }

  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> userOrderList = [];
  //List<CartModel> orderDetailsList = [];

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
    _ordersData = await DbHelper.fetchOrders();
    notifyListeners();
  }

//fetch items those are ordered from a specific user
// Future<QuerySnapshot<Map<String, dynamic>>> fetchOrderedItems(
//     OrderModel orderModel)async {
//   return  DbHelper.fetchOrderedItems(orderModel);
// }

}