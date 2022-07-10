import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/models/order_model.dart';
import 'package:provider/provider.dart';
import '../global/add_item_to_cart.dart';
import '../providers/order_provider.dart';
import '../screens/order_detail_screen.dart';

class MyOrderWidget extends StatefulWidget {
  List<DocumentSnapshot>? data;
  int? itemCount;
  String? orderId;
  List<String>? itemQuantityList;

  MyOrderWidget({
    Key? key,
    this.data,
    this.itemCount,
    this.orderId,
    this.itemQuantityList,
  }) : super(key: key);

  @override
  State<MyOrderWidget> createState() => _MyOrderWidgetState();
}

class _MyOrderWidgetState extends State<MyOrderWidget> {
  int i = 0;
  late OrderProvider _orderProvider;
  bool _init = true;

  @override
  Widget build(BuildContext context){
    print("object1");
    // print("items length = ${_orderProvider.itemModelList.length} of orderId = ${widget.orderModel!.orderId}");
    print("");
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetailScreen(orderID: widget.orderId)));
      },
      child: Container(
        //color: Colors.white10,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.black12, width: 4),
            borderRadius: BorderRadius.circular(5)),
        height: widget.itemCount!  * 125,
        child:  ListView.builder(
            itemCount: widget.itemCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              ItemModel itemModel = ItemModel.fromMap(widget.data![index].data()! as Map<String, dynamic>);
              for(int i=0; i<widget.data!.length; i++){
                print("itemId = ${widget.data![i].id}");
              }
              return PlacedOrderDesignWidtet(itemModel, context, widget.itemQuantityList![index]);
            }),
      ),
    );
  }

}

Widget PlacedOrderDesignWidtet(
    ItemModel itemModel, BuildContext context, separateItemsQuantityList) {
  // print("6 + separateItemsQuantityList = + ${separateItemsQuantityList} + XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxxxxxx");
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    child: Row(
      children: [
        /*CachedNetworkImage(
          imageUrl: itemModel.itemImageUrl!,
          width: 120,
        ),*/
        Text("${itemModel.itemID}"),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      itemModel.itemTitle!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      "Tk ${itemModel.price}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "x $separateItemsQuantityList",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}