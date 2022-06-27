import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DbHelper{
  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>>? fetchAllSellers()async{
     Stream<QuerySnapshot<Map<String, dynamic>>>? query;
    try{
       query = FirebaseFirestore.instance.collection("sellers").snapshots();
      return query;
    }catch(error){
      throw "error";
    }
  }
}