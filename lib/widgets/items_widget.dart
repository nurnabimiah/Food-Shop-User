import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/color_manager.dart';
import '../global/global_instance_or_variable.dart';
import '../models/items_model.dart';
import '../providers/cart_provider.dart';
import '../screens/user_items_details_screen.dart';
import 'add_and_remove_into_cart_widget.dart';
import 'decreasing_widget.dart';
import 'increasing_widget.dart';
import 'loading_container.dart';

class ItemsWidget extends StatefulWidget {
  ItemModel? itemModel;
  int? index;

  ItemsWidget({
    Key? key,
    this.itemModel,
    this.index,
  }) : super(key: key);

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  late CartProvider _cartProvider;
  int defaultQuantity = 1;
  int removeButtonValue = 10;

  //didChangeDependencies always will be called when data will change and it also rebuilds
  //ui.  but initState may not be called though data will change and it may not rebuild ui
  //if in this situation I use initState error will occurred(dependOnInheritedWidgetOfExactType
  // <_InheritedProviderScope<CartProvider?>>() or dependOnInheritedElement() was called before
  // _ItemsWidgetState.initState() completed).
  // but if use listen false then error goes...but provider data will not change though data changes
  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(int.parse(_cartProvider.itemIdAndQuantity[1]) > 1 && _cartProvider.doubleCheck == 0){
      _cartProvider.itemIdAndQuantity[1] = 1.toString();
      _cartProvider.itemCounter = 1;
    }
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.299,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserItemsDetailsScreen(
                        itemModel: widget.itemModel, index: widget.index)));
          },
          splashColor: Colors.red,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: widget.itemModel!.itemImageUrl == null
                        ? Container(
                            color: ColorManager.purple1,
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                                child: Text(
                              "Image not found", /*style: TextStyle(height: ),*/
                            )))
                        : CachedNetworkImage(
                            imageUrl: widget.itemModel!.itemImageUrl!,
                            placeholder: (context, url) =>
                                Center(child: LoadingContainer()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      // padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.0575,
                      color: Colors.black.withOpacity(0.50),
                      child: Text(
                        "${widget.itemModel!.shortInformation}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        maxLines: 2,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Tk " + widget.itemModel!.price.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                  DecreasingWidget(itemModel: widget.itemModel!),
                  Text(
                    _cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
                        ? "${_cartProvider.findQuantityInCartModelWithThisId(widget.itemModel!.itemID!)}"
                        : _cartProvider.itemIdAndQuantity[0] ==
                                widget.itemModel!.itemID! /*&& _cartProvider.doubleCheck == 1*/
                            ? _cartProvider.itemIdAndQuantity[1] /*this String*/
                            : /*"${_cartProvider.defaultItemQuanity}"*/ "1",
                    style: TextStyle(fontSize: 16),
                  ),

                  //increase widget
                  IncreasingWidget(
                    itemModel: widget.itemModel,
                  ),
                  //add and remove widget
                  AddandRemoveIntoCartWidget(
                    itemModel: widget.itemModel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
