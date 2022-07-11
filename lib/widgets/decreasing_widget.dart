import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class DecreasingWidget extends StatefulWidget {
  ItemModel? itemModel;
  double? buttonSize;

  DecreasingWidget({Key? key, this.itemModel, this.buttonSize})
      : super(key: key);

  @override
  State<DecreasingWidget> createState() => _DecreasingWidgetState();
}

class _DecreasingWidgetState extends State<DecreasingWidget> {
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
      // height: widget.buttonSize,
      child: IconButton(
        onPressed: () {
          //if already item in cart then just need to update
          if (_cartProvider.isAlreadyIncart(widget.itemModel!.itemID!)) {
            _cartProvider.decreaseItemQuantityInLocalOrFirebase(
                widget.itemModel!.itemID!);
          }
          //this is for local and sending itemCounter with addToCart method
          else {
            _cartProvider
                .decreaseItemCounterBeforeAddInCart(widget.itemModel!.itemID!);
          }
        },
        icon: const Icon(Icons.remove),
      ),
    );
  }
}
