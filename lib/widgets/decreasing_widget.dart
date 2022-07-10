// import 'package:flutter/material.dart';
// import 'package:foodfair/models/items_model.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/cart_provider.dart';
// import '../providers/item_counter.dart';
//
// class DecreasingWidget extends StatefulWidget {
//   ItemModel? itemModel;
//   double? buttonSize;
//   DecreasingWidget({Key? key, this.itemModel,this.buttonSize}) : super(key: key);
//
//   @override
//   State<DecreasingWidget> createState() => _DecreasingWidgetState();
// }
//
// class _DecreasingWidgetState extends State<DecreasingWidget> {
//   late CartProvider _cartProvider;
//   late ItemCounterProvider _itemCounterProvider;
//
//   //didChangeDependencies always will be called when data will change and it also rebuilds
//   //ui.  but initState may not be called though data will change and it may not rebuild u
//   @override
//   void didChangeDependencies() {
//     _cartProvider = Provider.of<CartProvider>(context);
//     _itemCounterProvider = Provider.of<ItemCounterProvider>(context);
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.buttonSize,
//       child: IconButton(
//           onPressed: () {
//             //if already item in cart then just need to update
//             if (_cartProvider
//                 .isAlreadyIncart(widget.itemModel!.itemID!)) {
//               _cartProvider.decreaseItemQuantityInFirebase(
//                   widget.itemModel!.itemID!);
//             }
//             //this is for local and sending itemCounter with addToCart method
//             else {
//               _itemCounterProvider.decreaseItemCounter();
//             }
//           },
//           icon: const Icon(Icons.remove)),
//     );
//   }
// }
