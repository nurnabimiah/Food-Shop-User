import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/db/db_helper.dart';
import 'package:foodfair/global/global_instance_or_variable.dart';
import 'package:foodfair/models/address_model.dart';

class AddressProvider with ChangeNotifier{
  Stream<QuerySnapshot<Map<String, dynamic>>>? _queryAddress;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get queryAddress => _queryAddress;
  List<AddressModel> addressModellist = [];
  int addressNumber = 0;
  //add user address
  Future<void> addAddress(AddressModel addressModel)async {
    DbHelper.addAddress(sPref!.getString("uid")! , addressModel);
  }

  //fetch user all addresses
  Future<void> fetchUserAllAddress()async{
      DbHelper.fetchUserAllAddress(sPref!.getString("uid")!).listen((event) {
        // _queryAddress = event.docs.;
         addressNumber = event.docs.length;

        addressModellist = List.generate(event.docs.length, (index) => AddressModel.fromMap(event.docs[index].data()));
        notifyListeners();
    }); //.then((value){
      //_queryAddress = value;
      // Stream<QuerySnapshot<Map<String, dynamic>>> _queryAddress2 = _queryAddress!;
      // notifyListeners();
      // _queryAddress2.forEach((element) {
      //   addressNumber = element.docs.length;
       // notifyListeners();
      //});
   // });
  }
  notifyListeners();
}