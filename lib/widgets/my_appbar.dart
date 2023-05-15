import 'package:flutter/material.dart';
import 'package:foodfair/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import 'container_decoration.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  //dont have
  //final String? sellerUID;
  final PreferredSizeWidget? bottom;
  MyAppBar({this.bottom, /*this.sellerUID*/});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(double.infinity, AppBar().preferredSize.height)
      : Size(double.infinity, AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text("foods"),
      centerTitle: true,
      //automaticallyImplyLeading: false,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen(/*sellerUID: widget.sellerUID*/)));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            Positioned(
              top: 3,
              right: 10,
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, ch) {
                  return Text(
                    cartProvider.cartModelList.length.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}