import 'package:flutter/material.dart';
import 'package:foodfair/screens/auth_screen.dart';
import 'package:provider/provider.dart';

import '../global/global_instance_or_variable.dart';
import '../models/items_model.dart';
import '../providers/cart_provider.dart';
import '../screens/user_home_screen.dart';

class AddandRemoveIntoCartWidget extends StatefulWidget {
  ItemModel? itemModel;
  double? buttonSize;

  AddandRemoveIntoCartWidget({Key? key, this.itemModel, this.buttonSize})
      : super(key: key);

  @override
  State<AddandRemoveIntoCartWidget> createState() =>
      _AddandRemoveIntoCartWidgetState();
}

class _AddandRemoveIntoCartWidgetState
    extends State<AddandRemoveIntoCartWidget> {
  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: widget.buttonSize,
      child: TextButton(
        child: Text(
          _cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)
              ? 'remove'
              : 'Add to cart',
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          primary: Colors.white,
          //Primary: Colors.white,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () async {
          //previous selleId is set with sellerId while fetching cartItems in cartProvider
          String currentSellerId = widget.itemModel!.sellerUID!;

          if (previousSellerId == '' || previousSellerId == currentSellerId) {
            previousSellerId = widget.itemModel!.sellerUID!;
            if (_cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)) {
              _cartProvider
                  .removeFromCartInLocalOrFirebase(widget.itemModel!.itemID!);

              //_cartProvider.rebuildItemWidget();
            } else {
              if(int.parse(_cartProvider.itemIdAndQuantity[1]) > 1 && _cartProvider.itemCounter == 1){
                _cartProvider.itemIdAndQuantity[1] = 1.toString();
              }
              if(widget.itemModel!.itemID != _cartProvider.getterItemId){
                _cartProvider.itemIdAndQuantity[1] = 1.toString();
              }
              _cartProvider.addToCartLocalOrFirebase(widget.itemModel!,
                  int.parse(_cartProvider.itemIdAndQuantity[1]));
            }
          } else {
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("order at first")));
            return await showDialog(
              context: (context),
              builder: (context) => alertDialogMethod(),
            );
          }
        },
      ),
    );
  }

  alertDialogMethod() {
    return AlertDialog(
      title: const Text('Remove your previous items?'),
      content: const Text(
          "You have added products in cart from another restaurant. Do you want to remove those?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
                  previousSellerId = '';
                  _cartProvider.clearCart();
                  _cartProvider.itemIdAndQuantity = ['-1', '1'];
                  // setState((){});
                  Navigator.pop(context);

                  // _cartProvider
                  //     .addToCartLocalOrFirebase(
                  //         widget.itemModel!,
                  //     int.parse(_beforeAddInCardItemCounterProvider.itemIdAndQuantity[1]));
                  //for default quantity

                  //Navigator.pop(context);
                },
                child: const Text("yes"))
          ],
        ),
      ],
    );
  }
}
