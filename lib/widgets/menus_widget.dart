import 'package:flutter/material.dart';
import 'package:foodfair/Screens/user_items_screen.dart';

import '../presentation/color_manager.dart';
import 'loading_container.dart';
import '../models/menus.dart';

class MenusWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;
  bool? netValue;
  MenusWidget({Key? key, this.model, this.context, this.netValue})
      : super(key: key);

  @override
  State<MenusWidget> createState() => _MenusWidgetState();
}

class _MenusWidgetState extends State<MenusWidget> {
  bool isLoading = false;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserItemsScreen(model: widget.model)));
        },
        splashColor: Colors.red,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: widget.model!.menuImageUrl == null
                  ? Container(
                      color: ColorManager.purple1,
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                          child: Text(
                        "Image not found", /*style: TextStyle(height: ),*/
                      )))
                  : /*widget.netValue == false
                          ? LoadingContainer()
                          : */
                  Image.network(
                      widget.model!.menuImageUrl!,
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: /*CircularProgressIndicator*/ LoadingContainer(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
            ),
            Text(
              "${widget.model!.menuTitle}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${widget.model!.menuShortInformation}",
              style: TextStyle(fontSize: 18),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
