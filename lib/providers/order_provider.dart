import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodfair/db/db_helper.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/models/order_model.dart';

import '../global/global_instance_or_variable.dart';

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

  //add order
  Future<void> addOrder(OrderModel orderModel, String orderId) async {
    return DbHelper.addOrder(orderModel, orderId);
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
