import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/sellers_model.dart';
import 'package:foodfair/providers/cart_provider.dart';
import 'package:foodfair/providers/sellers_provider.dart';
import 'package:foodfair/widgets/my_drawer.dart';
import 'package:foodfair/widgets/seller_profile_design.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../widgets/error_dialog.dart';
import '../global/color_manager.dart';
import '../global/global_instance_or_variable.dart';
import '../providers/internet_connectivity.dart';
import '../widgets/container_decoration.dart';
import '../widgets/loading_container.dart';
import 'cart_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static final String path = "/homeScreen";

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late SellersProvider _sellersProvider;
  late CartProvider _cartProvider;
  late CartProvider _cartProvider2;
  bool _init = true;
  var isLoading = true;
  TextEditingController searchController = TextEditingController();

 @override
  void initState() {
   super.initState();
  // print("1 ininState = $isLoading");
   if(_init){
    // print("2 ininState = $isLoading");
     _sellersProvider = Provider.of<SellersProvider>(context, listen: false);
     _cartProvider = Provider.of<CartProvider>(context, listen: false);
     _sellersProvider.fetchAllSellers().then((value) {
       _cartProvider.fetchCartItemsForSpecificUser();
       Provider.of<InternetConnectivityProvider>(context, listen: false)
           .startMonitoring().then((value){
         setState((){
           isLoading = false;
           //print("isLoading = $isLoading");
         });
       });
     });
   }
   _init = false;
  }

  //this only for updating cartListlength
  void didChangeDependencies(){
    _cartProvider2 = Provider.of<CartProvider>(context);
   super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("user item screen ");
    return Scaffold(
      backgroundColor: ColorManager.lightPink,
      drawer: MyDrawer(),
      body: isLoading ? Center(child: CircularProgressIndicator(),) :
        CustomScrollView(
              slivers: [
                SliverAppBar(
                  actions: [
                    card(),
                  ],
                  //appbar will not disapper
                  pinned: true,
                  //when scroll down star then image will start showing
                  floating: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.12,
                  title: Transform(
                    // you can forcefully translate values left side using Transform
                    transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                    child: Text("foodfair"),
                  ),
                  centerTitle: true,
                  flexibleSpace: flexibleSpaceBarMethod(),
                ),

                SliverToBoxAdapter(
                  child: carouselSliderMethod(),
                ),
                StreamBuilder(
                  stream: _sellersProvider.allSellersData,
                  builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
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
                        :
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                Sellers sModel = Sellers.frmMap(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);
                                return SellerProfileDesign(
                                  sellerModel: sModel,
                                  context: context,
                                );
                              },
                              childCount: snapshot.data!.docs.length,
                            ),
                          );
                  },
                ),
              ],
            ),

    );
  }

  card() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
                context,
                CartScreen.path);
          },
          icon: const Icon(Icons.shopping_cart),
        ),
        Positioned(
          top: 3,
          right: 10,
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, ch) {
              return Text(
                _cartProvider2.cartModelList.length.toString(),
                style: const TextStyle(
                    color: Colors.white, fontSize: 13),
              );
            },
          ),
        )
      ],
    );
  }

  flexibleSpaceBarMethod() {
   return FlexibleSpaceBar(
     background: Container(
       decoration: const ContainerDecoration().decoaration(),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         //crossAxisAlignment: CrossAxisAlignment.end,
         children: [
           Padding(
             padding: const EdgeInsets.only(
                 left: 35.0, right: 40, bottom: 3, top: 2),
             child: SizedBox(
               height: 30,
               child: TextField(
                 controller: searchController,
                 decoration: InputDecoration(
                   //isCollapsed: true,
                   //isDense: true,
                   contentPadding:
                   EdgeInsets.only(top: 0, bottom: 0),
                   border: const OutlineInputBorder(
                     borderRadius: BorderRadius.all(
                       Radius.circular(60),
                     ),
                     borderSide: BorderSide.none,
                   ),
                   /*prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    //color: Colors.cyan,
                                  ),*/
                   prefixIcon: const Align(
                     widthFactor: 0.5,
                     //heightFactor: 5.0,
                     child: Icon(
                       Icons.search,
                     ),
                   ),
                   filled: true,
                   fillColor: ColorManager.grey3,
                   hintText: "search with food or Restaurant",
                   hintStyle: const TextStyle(
                     //fontFamily: 'Lexend Deca ',
                     //color: Color(0xFF95A1AC),
                     fontSize: 14,
                     fontWeight: FontWeight.normal,
                   ),
                 ),
               ),
             ),
           ),
         ],
       ),
     ),
   );
  }

  carouselSliderMethod() {
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Container(
       height: MediaQuery.of(context).size.height * .3,
       width: MediaQuery.of(context).size.width,
       child: CarouselSlider(
         options: CarouselOptions(
           height: MediaQuery.of(context).size.height * .3,
           aspectRatio: 16 / 9,
           viewportFraction: 0.8,
           initialPage: 0,
           enableInfiniteScroll: true,
           reverse: false,
           //autoPlay: true,
           autoPlayInterval: const Duration(seconds: 2),
           autoPlayAnimationDuration:
           const Duration(milliseconds: 500),
           autoPlayCurve: Curves.decelerate,
           enlargeCenterPage: true,
           scrollDirection: Axis.horizontal,
         ),
         items: sliderItems.map((index) {
           return Builder(builder: (BuildContext context) {
             return Container(
               width: MediaQuery.of(context).size.width,
               margin: EdgeInsets.all(10),
               decoration: BoxDecoration(
                 border: Border.all(
                   color: ColorManager.grey5,
                   width: 3,
                 ),
                 borderRadius: BorderRadius.circular(7),
               ),
               child: Image.asset(
                 index,
                 fit: BoxFit.cover,
               ),
             );
           });
         }).toList(),
       ),
     ),
   );
  }
}
