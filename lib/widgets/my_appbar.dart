import 'package:flutter/material.dart';

import 'container_decoration.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  MyAppBar({this.bottom});

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
      title: Text("foods"),
      centerTitle: true,
      //automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const ContainerDecoration().decoaration(),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
            const Positioned(
              top: 3,
              right: 10,
              child: Center(
                  child: Text(
                "0",
                style: TextStyle(color: Colors.white, fontSize: 13),
              )),
            )
          ],
        ),
      ],
    );
  }
}
