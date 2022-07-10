import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/db/db_helper.dart';
import 'package:foodfair/global/global_instance_or_variable.dart';
import 'package:foodfair/models/address_model.dart';

class AddressProvider with ChangeNotifier{
  Stream<QuerySnapshot<Map<String, dynamic>>>? _queryAddress;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get queryAddress => _queryAddress;
  //add user address
  Future<void> addAddress(AddressModel addressModel)async {
    DbHelper.addAddress(sPref!.getString("uid")! , addressModel);
  }

  //fetch user all addresses
  Future<void> fetchUserAllAddress()async{

    _queryAddress = await DbHelper.fetchUserAllAddress(sPref!.getString("uid")!);
    // _queryAddress!.forEach((element) {
    //   print("object #= ${element.docs[0].id}  ");
    //   print("object #= ${element.docs[1].id}  ");
    //   print("object #= ${element.docs[2].id}  ");
    // });
    //print("...........queryAdd = ${_queryAddress!.doc[0].toString()}");
    notifyListeners();
  }
}