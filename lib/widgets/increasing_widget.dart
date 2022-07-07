import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items_model.dart';
import '../providers/cart_provider.dart';
import '../providers/item_counter_provider.dart';

class IncreasingWidget extends StatefulWidget {
  ItemModel? itemModel;
  double? buttonSize;
  IncreasingWidget({Key? key, this.itemModel, this.buttonSize}) : super(key: key);

  @override
  State<IncreasingWidget> createState() => _IncreasingWidgetState();
}

class _IncreasingWidgetState extends State<IncreasingWidget> {
  late CartProvider _cartProvider;
  late ItemCounterProvider _itemCounterProvider;

  //didChangeDependencies always will be called when data will change and it also rebuilds
  //ui.  but initState may not be called though data will change and it may not rebuild u
  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _itemCounterProvider = Provider.of<ItemCounterProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.buttonSize,
      child: IconButton(
          onPressed: () {
            if (_cartProvider
                .isAlreadyIncart(widget.itemModel!.itemID!)) {
              _cartProvider.increaseItemQuantityInFirebase(
                  widget.itemModel!.itemID!);
            } else {
              _itemCounterProvider.increaseItemCounter();
            }
          },
          icon: const Icon(Icons.add)),
    );
  }
}
