import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/color_manager.dart';
import '../global/global_instance_or_variable.dart';
import '../global/internet_connection.dart';
import '../models/menus_model.dart';
import '../models/sellers_model.dart';
import '../providers/internet_connectivity.dart';
import '../providers/sellers_provider.dart';
import '../widgets/container_decoration.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_container.dart';
import '../widgets/menus_widget.dart';
import '../widgets/text_widget_header.dart';

class UserMenusScreen extends StatefulWidget {
  final Sellers? sellerModel;

  const UserMenusScreen({
    Key? key,
    this.sellerModel,
  }) : super(key: key);

  @override
  State<UserMenusScreen> createState() => _UserMenusScreenState();
}

class _UserMenusScreenState extends State<UserMenusScreen> {
  late SellersProvider _sellersProvider;
  bool _init = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_init) {
      _sellersProvider = Provider.of<SellersProvider>(context, listen: false);
      _sellersProvider
          .fetchSpecificSellerMenus(widget.sellerModel!.sellerUID!)
          .then((value) {
        Provider.of<InternetConnectivityProvider>(context, listen: false)
            .startMonitoring()
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
      _init = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("menu screen");
    return Scaffold(
      backgroundColor: ColorManager.lightPink,
      appBar: AppBar(
        title: Text("foods"),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const ContainerDecoration().decoaration(),
        ),
      ),
      //drawer: MyDrawer(),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<InternetConnectivityProvider>(
              builder: (context, netProvider, _) {
              if (netProvider.isOnline == false) {
                return const Center(
                  child: Text(
                      "Make sure your internet connection is stable"),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    //pinned: true,
                    delegate: TextWidgetHeader(
                        title: widget.sellerModel!.sellerName! + "'s menus"),
                  ),
                  StreamBuilder(
                    stream: _sellersProvider.specificSellerMenus,
                    builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
                      sellerUIDD = widget.sellerModel!.sellerUID;
                      if (snapshot.hasError) {
                        ErrorDialog(
                          message: "${snapshot.error}",
                        );
                        //return  Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasError) {
                        return Text("No net");
                      }

                      return !snapshot.hasData
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: LoadingContainer(),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  MenusModel menuModel = MenusModel.fromMap(
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>);
                                  return MenusWidget(
                                    model: menuModel,
                                    context: context,
                                    sellerUID: widget.sellerModel!.sellerUID,
                                    //netValue: model.isOnline,
                                  );
                                },
                                childCount: snapshot.data!.docs.length,
                              ),
                            );
                    },
                  ),
                ],
              );
            }),
    );
  }
}
