import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/models/order_model.dart';
import 'package:foodfair/providers/order_provider.dart';
import 'package:foodfair/widgets/progress_bar.dart';
import 'package:foodfair/global/add_item_to_cart.dart';
import 'package:foodfair/global/global_instance_or_variable.dart';
import 'package:foodfair/widgets/my_order_wiget.dart';
import 'package:foodfair/widgets/simple_appbar.dart';
import 'package:provider/provider.dart';

class MyOrderSceen extends StatefulWidget {
  const MyOrderSceen({Key? key}) : super(key: key);

  @override
  State<MyOrderSceen> createState() => _MyOrderSceenState();
}

class _MyOrderSceenState extends State<MyOrderSceen> {
  late OrderProvider _orderProvider;
  bool _init = true;

  // @override
  // void initState() {
  //   super.initState();
  //   if (_init) {
  //     _orderProvider = Provider.of<OrderProvider>(context, listen: false);
  //     _orderProvider.fetchOrders().then((value) {
  //       setState(() {
  //         //print("10 + ordermodel = + + BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBbbbb");
  //         _init = false;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // print("9 + ordermodel = + + BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBbbbb");
    print('');
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppbar(title: "My orders"),
        body: StreamBuilder<QuerySnapshot>(
                //here we get the order list of order collection which are normal
               // stream: _orderProvider.ordersData,
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(sPref!.getString("uid"))
                    .collection("orders")
                    .where("status", isEqualTo: "normal")
                    .orderBy("orderTime", descending: true)
                    .snapshots(),
                builder: (c, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {

                            print(
                                "orderId in myorderScreen = + ${snapshot.data!.docs[index].id}");
                            OrderModel orderModel = OrderModel.fromMap(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);
                            List<String> itemList = separatedItemIDFromOrdersCollection(orderModel.productIDs);
                            for(int i=0; i<itemList.length; i++){
                              print("itemId_1 in orscreen = ${itemList[i]}");
                            }
                            print('');
                            //inside of specific orderId have many itemQuantity
                            return FutureBuilder<QuerySnapshot>(
                                // future: _orderProvider.fetchOrderedItems(orderModel),
                                //future: _orderProvider.fetchOrderedItems(orderModel),
                              future: FirebaseFirestore.instance
                                  .collection(
                                  "items") /*insdie of items colleciton we will search which items are ordered.*/
                                  .where("itemID",
                                  /*if itemID is exist in separateOrdersItemsIDs*/
                                  whereIn: itemList/*separatedItemIDFromOrdersCollection(
                                      (snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>)["productIDs"])*/)
                                  .get(),
                                builder: (context, snap) {
                                    if(!snap.hasData){
                                      return Text('');
                                    }
                                  for(int i=0; i<snap.data!.docs.length; i++){
                                    print("itemId_2 in orscreen = ${snap.data!.docs[i].id} + orderId = ${orderModel.orderId}");
                                  }
                                  return !snap.hasData ? Center(child: CircularProgressIndicator()) : MyOrderWidget(
                                    data: snap.data!.docs,
                                    itemCount: snap.data!.docs.length,
                                    orderId: orderModel.orderId,
                                    itemQuantityList : separateItemQuantityFromOrdersCollection(
                                  (snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>)[
                                  "productIDs"]),
                                  );
                                });
                          })
                      : Center(
                          child: circularProgress(),
                        );
                },
              ),
      ),
    );
  }
}
