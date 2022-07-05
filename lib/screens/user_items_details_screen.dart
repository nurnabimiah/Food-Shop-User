import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/widgets/my_appbar.dart';
import 'package:provider/provider.dart';
import '../global/global_instance_or_variable.dart';
import '../providers/cart_provider.dart';
import '../widgets/loading_container.dart';

class UserItemsDetailsScreen extends StatefulWidget {
  final ItemModel? itemModel;
  String? sellerUID;

  UserItemsDetailsScreen({
    Key? key,
    this.itemModel,
    this.sellerUID,
  }) : super(key: key);

  @override
  State<UserItemsDetailsScreen> createState() => _UserItemsDetailsScreenState();
}

class _UserItemsDetailsScreenState extends State<UserItemsDetailsScreen> {
  int itemCounter = 1;
  late CartProvider _cartProvider;

  //didChangeDependencies always will be called when data will change and it also rebuilds
  //ui.  but initState may not be called though data will change and it may not rebuild ui.
  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    setState((){
      itemCounter = 1;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  IconButton(
                      onPressed: () {
                        //if already item in cart then just need to update
                        if (_cartProvider.isAlreadyIncart(
                            widget.itemModel!.itemID!)) {
                          _cartProvider.decreaseItemQuantityInFirebase(widget.itemModel!.itemID!);
                        }
                        //this is for local and sending itemCounter with addToCart method
                        else {
                          setState(() {
                            if (itemCounter == 1) {}
                            else{
                              //locally increasing for the first time item added in cart with addToCart method
                              itemCounter = itemCounter - 1;
                            }

                          });
                        }
                      },
                      icon: const Icon(Icons.remove)),
                  Text(_cartProvider.isAlreadyIncart(
                      widget.itemModel!.itemID!) ?
                     "${(_cartProvider.findQuantityInCartModelWithThisId(
                    widget.itemModel!.itemID!))}"
                         : "${itemCounter}"),
                  IconButton(
                      onPressed: () {
                        if(_cartProvider.isAlreadyIncart(
                            widget.itemModel!.itemID!)) {
                          _cartProvider.increaseItemQuantityInFirebase(widget.itemModel!.itemID!);
                        } else {
                          setState(() {
                            //locally increasing for the first time item added in cart with addToCart method
                            itemCounter = itemCounter + 1;
                          });
                        }
                      },
                      icon: const Icon(Icons.add)),
                  TextButton(
                    child: Text(
                        _cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
                            ? 'remove'
                            : 'Add to cart'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                      primary: Colors.white,
                      //Primary: Colors.white,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                    ),
                    onPressed: () async {
                      String currentSellerId = widget.itemModel!.sellerUID!;

                      //previous selleId is set with sellerId while fetching cartItems in cartProvider
                      if (previousSellerId == '' ||
                          previousSellerId == currentSellerId) {
                        // previousSellerId = widget.itemModel!.sellerUID!;
                        // _cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
                        //     ?
                        // _cartProvider.removeFromCart(widget.itemModel!.itemID!)
                        //     :
                        // _cartProvider.addToCart(widget.itemModel!, itemCounter);
                        print("dfjdlfkjsdalfjasdlfkjasd");
                      }
                      else {
                        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("order at first")));
                        return await showDialog(
                            context: (context), builder: (context) =>
                            AlertDialog(
                              title: const Text('Remove your previous items?'),
                              content: const Text(
                                  "You have added products in cart from another restaurant. Do you want to remove those?"),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: () {
                                      //if user increases itemCounter but not able to
                                      // add in cart then it is necessary.
                                      setState((){
                                        itemCounter = 1;
                                      });
                                      Navigator.pop(context);
                                    }, child: const Text("no")),
                                    TextButton(onPressed: () {
                                      _cartProvider.clearCart().then((value){
                                        _cartProvider.addToCart(widget.itemModel!, itemCounter);
                                      });
                                      Navigator.pop(context);
                                    }, child: const Text("yes"))
                                  ],
                                ),
                              ],
                            ));
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
