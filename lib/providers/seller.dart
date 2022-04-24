import 'package:flutter/material.dart';
import 'package:foodfair/global/global_instance_or_variable.dart';
import '../models/sellers_model.dart';

class SellerProvider with ChangeNotifier{

   //Map<String, dynamic> _seller = sPref!.getString("sellerUID")!;
   final String  _seller = sPref!.getString("sellerUID")!;
  //_seller.add()
  String get sellerUID => _seller;
}