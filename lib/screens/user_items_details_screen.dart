import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/providers/item_counter_provider.dart';
import 'package:foodfair/widgets/my_appbar.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/add_and_remove_into_cart_widget.dart';
import '../widgets/decreasing_widget.dart';
import '../widgets/increasing_widget.dart';
import '../widgets/loading_container.dart';

class UserItemsDetailsScreen extends StatefulWidget {
  final ItemModel? itemModel;

  UserItemsDetailsScreen({
    Key? key,
    this.itemModel,
  }) : super(key: key);

  @override
  State<UserItemsDetailsScreen> createState() => _UserItemsDetailsScreenState();
}

class _UserItemsDetailsScreenState extends State<UserItemsDetailsScreen> {
  late CartProvider _cartProvider;
  late ItemCounterProvider _itemCounterProvider;

  //didChangeDependencies always will be called when data will change and it also rebuilds
  //ui.  but initState may not be called though data will change and it may not rebuild ui.
  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _itemCounterProvider = Provider.of<ItemCounterProvider>(context);
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
          mainAxisSize: MainAxisSize.min,
          children: [
            DecreasingWidget(itemModel: widget.itemModel!, buttonSize: 40),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(_cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
                  ? "${(_cartProvider.findQuantityInCartModelWithThisId(widget.itemModel!.itemID!))}"
                  : "${_itemCounterProvider.itemCounter}"),
            ),
            IncreasingWidget(itemModel: widget.itemModel!, buttonSize: 40),
            AddandRemoveIntoCartWidget(itemModel: widget.itemModel!, buttonSize: 40),
          ],
        ),
      ),
    );
  }
}
