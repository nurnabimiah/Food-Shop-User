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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (_init) {
      _orderProvider = Provider.of<OrderProvider>(context, listen: false);
      _orderProvider.fetchOrders().then((value) {
        // print(
        //     "orderId in myorderScreen = +   ....id}");
        setState(() {
          _isLoading = false;
        });
      });
      _init = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppbar(title: "My orders"),
        body:  _isLoading ? Center(child: CircularProgressIndicator(),) : StreamBuilder<QuerySnapshot>(
          //here we get the order list of order collection which are normal
          stream: _orderProvider.ordersData,
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      print(
                          "orderId in myorderScreen = +1   ....id}");
                      print(
                          "orderId in myorderScreen = + ${snapshot.data!.docs[index].id}");
                      OrderModel orderModel = OrderModel.fromMap(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);

                      print('');
                      //inside of specific orderId have many itemQuantity
                      return StreamBuilder<QuerySnapshot>(
                          // future: _orderProvider.fetchOrderedItems(orderModel),
                          //future: _orderProvider.fetchOrderedItems(orderModel),
                          // future: FirebaseFirestore.instance
                          //     .collection(
                          //         "items") /*insdie of items colleciton we will search which items are ordered.*/
                          //     /*.where("itemID",
                          //         /*if itemID is exist in separateOrdersItemsIDs*/
                          //         whereIn: itemList/*separatedItemIDFromOrdersCollection(
                          //             (snapshot.data!.docs[index].data()!
                          //             as Map<String, dynamic>)["productIDs"])*/)*/
                          //     .get(),
                          stream: _orderProvider.fetchItemsOfOrderDetails(orderModel.orderId!),
                          builder: (context, snap) {
                            print(
                                "orderId in myorderScreen = +   ....id}");
                            if (!snap.hasData) {
                              return Text('');
                            }
                            for (int i = 0; i < snap.data!.docs.length; i++) {
                              print(
                                  "itemId_2 in orscreen = ${snap.data!.docs[i].id} + orderId = ${orderModel.orderId}");
                            }
                            return !snap.hasData
                                ? Center(child: CircularProgressIndicator())
                                : MyOrderWidget(
                                    data: snap.data!.docs,
                                    itemCount: snap.data!.docs.length,
                                    orderId: orderModel.orderId,
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
