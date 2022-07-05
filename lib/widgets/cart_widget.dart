import 'package:flutter/material.dart';
import 'package:foodfair/models/cart_model.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartWidget extends StatefulWidget {
  final CartModel? cartModel;
  final int? quantity;
  final double? total;

  CartWidget({
    Key? key,
    this.cartModel,
    this.quantity,
    this.total,
  }) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  // double? price = widget.itemModel!.price;
  @override
  Widget build(BuildContext context) {
    print("qunatity = ${widget.quantity}");
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: InkWell(
        child: Card(

          borderOnForeground: false,
          shape: const RoundedRectangleBorder(
            // side: BorderSide(
            //   color: Colors.white,
            //   width: 2,
            // ),
            // borderRadius: BorderRadius.all(
            //   Radius.circular(10),
            // ),
          ),
          elevation: 10,
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.14,
                width: MediaQuery.of(context).size.height * 0.16,
                child: CachedNetworkImage(
                  imageUrl: widget.cartModel!.itemImageUrl!,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  //color: Colors.green,
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.height * 0.19,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 8, left: 3, bottom: 5),
                        child: Text(
                          widget.cartModel!.itemTitle!,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          maxLines: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, bottom: 5),
                        child: Row(
                          children: [
                            const Text(
                              "Price: ",
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Text(
                              widget.cartModel!.price.toString(),
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, bottom: 5),
                        child: Row(
                          children: [
                            const Text(
                              "Total: ",
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Text(
                              "${widget.cartModel!.price! * widget.quantity!}",
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                //color: Colors.red,
                height: MediaQuery.of(context).size.height * 0.14,
                width: MediaQuery.of(context).size.height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "x ",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        "${widget.quantity.toString()}",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}