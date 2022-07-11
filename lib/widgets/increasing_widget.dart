import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/global_instance_or_variable.dart';
import '../models/items_model.dart';
import '../providers/cart_provider.dart';

class IncreasingWidget extends StatefulWidget {
  ItemModel? itemModel;
  double? buttonSize;

  IncreasingWidget({Key? key, this.itemModel, this.buttonSize})
      : super(key: key);

  @override
  State<IncreasingWidget> createState() => _IncreasingWidgetState();
}

class _IncreasingWidgetState extends State<IncreasingWidget> {
  late CartProvider _cartProvider;

  //didChangeDependencies always will be called when data will change and it also rebuilds
  //ui.  but initState may not be called though data will change and it may not rebuild u
  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        onPressed: () async {
          //previous selleId is set with sellerId while fetching cartItems in cartProvider
          String currentSellerId = widget.itemModel!.sellerUID!;

          if (previousSellerId == '' || previousSellerId == currentSellerId) {
            previousSellerId = widget.itemModel!.sellerUID!;

            if (_cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)) {
              _cartProvider.increaseItemQuantityInLocalOrFirebase(
                  widget.itemModel!.itemID!);
            } else {
              _cartProvider.increaseItemCounterBeforeAddInCart(
                  widget.itemModel!.itemID!);
            }
          } else {
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("order at first")));
            return await showDialog(
                context: (context), builder: (context) => alertDialogMethod());
          }
        },
        icon: const Icon(Icons.add),
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
