import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/providers/before_add_in_cart_item_counter_provider.dart';
import 'package:foodfair/widgets/my_appbar.dart';
import 'package:provider/provider.dart';
import '../global/global_instance_or_variable.dart';
import '../providers/cart_provider.dart';
import '../widgets/add_and_remove_into_cart_widget.dart';
import '../widgets/decreasing_widget.dart';
import '../widgets/increasing_widget.dart';
import '../widgets/loading_container.dart';

class UserItemsDetailsScreen extends StatefulWidget {
  final ItemModel? itemModel;
  int? index;
  UserItemsDetailsScreen({
    Key? key,
    this.itemModel,
    this.index,
  }) : super(key: key);

  @override
  State<UserItemsDetailsScreen> createState() => _UserItemsDetailsScreenState();
}

class _UserItemsDetailsScreenState extends State<UserItemsDetailsScreen> {
  late CartProvider _cartProvider;

  //didChangeDependencies always will be called when data will change and it also rebuilds
  //ui.  but initState may not be called though data will change and it may not rebuild ui.
  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuil..........................");
    return Scaffold(
      appBar: MyAppBar(/*sellerUID: widget.itemModel!.sellerUID*/),
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: widget.itemModel!.itemImageUrl.toString(),
            placeholder: (context, url) => Center(child: LoadingContainer()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.bottomRight,
            //color: Colors.red,
            child: Text(
              "Tk " + widget.itemModel!.price.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              widget.itemModel!.shortInformation.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
            child: Text(
              widget.itemModel!.itemDescription.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
          //  DecreasingWidget(itemModel: widget.itemModel!, buttonSize: 40),
          //   Padding(
          //     padding: const EdgeInsets.only(top: 10),
          //     child: Text(_cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
          //         ? "${(_cartProvider.findQuantityInCartModelWithThisId(widget.itemModel!.itemID!))}"
          //         : "${widget.itemModel.}"),
          //   ),
           // IncreasingWidget(itemModel: widget.itemModel!, buttonSize: 40),
           // AddandRemoveIntoCartWidget(itemModel: widget.itemModel!, buttonSize: 40),

            SizedBox(
              // height: widget.buttonSize,
              child: IconButton(
                  onPressed: () {
                    //if already item in cart then just need to update
                    if (_cartProvider
                        .isAlreadyIncart(widget.itemModel!.itemID!)) {
                      //it needs (i)
                      setState((){});
                      _cartProvider.decreaseItemQuantityInLocalOrFirebase(
                          widget.itemModel!.itemID!);
                    }
                    //this is for local and sending itemCounter with addToCart method
                    else {
                      // _itemCounterProvider.decreaseItemCounter();
                      // setState(() {
                      //   _itemCounter != 1 ?  _itemCounter -= 1 : _itemCounter;
                      // });
                      _cartProvider.decreaseItemCounterBeforeAddInCart(widget.itemModel!.itemID!);
                    }
                  },
                  icon: const Icon(Icons.remove)),
            ),


            Text(
              _cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
                  ? "${_cartProvider.findQuantityInCartModelWithThisId(widget.itemModel!.itemID!)}" /*"+${_itemCounterIsAlreadyInCart}"*/
                  : _cartProvider.itemIdAndQuantity[0] == widget.itemModel!.itemID! ?  _cartProvider.itemIdAndQuantity[1] : "${_cartProvider.defaultItemQuanity}",
              style: TextStyle(fontSize: 16),
            ),

            IconButton(
                onPressed: () {
                  if (_cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)) {
                    print("I am in + button100 = ");
                    //(i)here setState need because again this whole screen need to be rebuild to
                    //call this findQuantityInCartModelWithThisId method() again
                    //one thing keep in mind didChangeDependencies or init will not rebuild
                    //setState(() {});
                    //though already in cart but this cart not assigned in firebase then else
                    // to increase
                    _cartProvider.increaseItemQuantityInLocalOrFirebase(
                        widget.itemModel!.itemID!);
                  } else {
                    // setState(() {
                    //   _itemCounter += 1;
                    // });
                    _cartProvider.increaseItemCounterBeforeAddInCart(widget.itemModel!.itemID!);
                  }
                },
                icon: const Icon(Icons.add)),

            SizedBox(
              //height: widget.buttonSize,
              child: TextButton(
                child: Text(
                  _cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
                      ? 'remove'
                      : 'Add to cart',
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  primary: Colors.white,
                  //Primary: Colors.white,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                ),
                onPressed: () async {

                  //previous selleId is set with sellerId while fetching cartItems in cartProvider
                  String currentSellerId = widget.itemModel!.sellerUID!;

                  if (previousSellerId == '' ||
                      previousSellerId == currentSellerId) {
                    previousSellerId = widget.itemModel!.sellerUID!;
                    if (_cartProvider
                        .isAlreadyIncart(widget.itemModel!.itemID!)) {
                      _cartProvider
                          .removeFromCartInLocalOrFirebase(widget.itemModel!.itemID!);
                      _cartProvider.defaultItemQuanity;
                      //_itemCounterProvider.setItemCounterOne();
                    } else {
                      _cartProvider.addToCartLocalOrFirebase(
                          widget.itemModel!, int.parse(_cartProvider.itemIdAndQuantity[1]));
                    }
                  } else {
                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("order at first")));
                    return await showDialog(
                        context: (context),
                        builder: (context) => AlertDialog(
                          title: const Text(
                              'Remove your previous items?'),
                          content: const Text(
                              "You have added products in cart from another restaurant. Do you want to remove those?"),
                          actions: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      //if user increases itemCounter but not able to
                                      // add in cart then it is necessary.
                                      //_itemCounterProvider.setItemCounterOne();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("no")),
                                TextButton(
                                    onPressed: () {
                                      _cartProvider
                                          .clearCart()
                                          .then((value) {
                                        _cartProvider
                                            .addToCartLocalOrFirebase(
                                            widget.itemModel!,
                                            int.parse(_cartProvider.itemIdAndQuantity[1]));
                                      });
                                      //Navigator.pop(context);
                                    },
                                    child: const Text("yes"))
                              ],
                            ),
                          ],
                        ));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
