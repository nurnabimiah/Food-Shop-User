import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodfair/global/global_instance_or_variable.dart';

addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  print("foodItemId = $foodItemId + BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBbb");
  List<String>? tempCartList = sPref!.getStringList("userCart");
  tempCartList!.add(foodItemId! + ":$itemCounter");
//1650134716838673
  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({
    "userCart": tempCartList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added Successfully");
    sPref!.setStringList("userCart", tempCartList);
  });
}
