import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/db/db_helper.dart';

class SellersProvider with ChangeNotifier{
  Stream<QuerySnapshot<Map<String, dynamic>>>? _queryData;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get allSellersData => _queryData;

  Future<void> fetchAllSellers()async{
    _queryData = await DbHelper.fetchAllSellers();
    notifyListeners();
  }
}