import 'package:flutter/material.dart';
import 'container_decoration.dart';

class SimpleAppbar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  SimpleAppbar({this.bottom});

    @override
  Size get preferredSize => bottom == null
      ? Size(double.infinity, AppBar().preferredSize.height)
      : Size(double.infinity, AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Foods"),
      flexibleSpace: Container(
        decoration: const ContainerDecoration().decoaration(),
      ),
    );
  }
}
