import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/sellers_model.dart';
import 'package:foodfair/providers/cart_item_quantity_provider.dart';
import 'package:foodfair/widgets/my_drawer.dart';
import 'package:foodfair/widgets/seller_profile_design.dart';
import 'package:provider/provider.dart';
import '../exceptions/error_dialog.dart';
import '../presentation/color_manager.dart';
import '../providers/internet_connectivity_provider.dart';
import '../widgets/container_decoration.dart';
import '../widgets/loading_container.dart';
import 'cart_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final sliderItems = [
    "slider/0.jpg",
    "slider/1.jpg",
    "slider/2.jpg",
    "slider/3.jpg",
    "slider/4.jpg",
    "slider/5.jpg",
    "slider/6.jpg",
    "slider/7.jpg",
    "slider/8.jpg",
    "slider/9.jpg",
    "slider/10.jpg",
    "slider/11.jpg",
    "slider/12.jpg",
    "slider/13.jpg",
    "slider/14.jpg",
    "slider/15.jpg",
    "slider/16.jpg",
    "slider/17.jpg",
    "slider/18.jpg",
    "slider/19.jpg",
    "slider/20.jpg",
    "slider/21.jpg",
    "slider/22.jpg",
    "slider/23.jpg",
    "slider/24.jpg",
    "slider/25.jpg",
    "slider/26.jpg",
    "slider/27.jpg",
  ];
  var isLoading = true;
  TextEditingController searchController = TextEditingController();

  //CollectionReference? query;
  // CollectionReference<Object?>? getDataFromFirebase() {
  //   final query = FirebaseFirestore.instance.collection("sellers");
  //   return query;
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>>? query3;
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
      getDataFromFirebase() async {
    final query = FirebaseFirestore.instance.collection("sellers").snapshots();
    return query;
  }

  @override
  void initState() {
    getDataFromFirebase().then((value) {
      setState(() {
        Provider.of<InternetConnectivityProvider>(context, listen: false)
            .startMonitoring();
        query3 = value;
      });
    });
    super.initState();
  }

  //   @override
  // void initState() {
  //   super.initState();
  //   Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          centerTitle: false,
          //titleSpacing: 10.0,
          //automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const ContainerDecoration().decoaration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 5, top: 10),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      //isCollapsed: true,
                      //isDense: true,
                      contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(60),
                          ),
                          borderSide: BorderSide.none),
                      prefixIcon: const Icon(
                        Icons.search,
                        //color: Colors.cyan,
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
              ],
            ),
          ),
          title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(60.0, 0.0, 0.0),
            child: Text("title"),
          ),
        ),
      ),*/
      drawer: MyDrawer(),
      body: Consumer<InternetConnectivityProvider>(
        builder: (consumerContext, model, child) {
          print(
              " 10   model.isOnline + ${model.isOnline} + FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFf ");
          if (model.isOnline != null) {
            return /*model.isOnline!
                ? */
                CustomScrollView(
              slivers: [
                SliverAppBar(
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                        /*sellerUID: widget.sellerUID*/)));
                          },
                          icon: const Icon(Icons.shopping_cart),
                        ),
                        Positioned(
                          top: 3,
                          right: 10,
                          child: Consumer<CartItemQuanityProvider>(
                            builder: (context, itemCounter, ch) {
                              return Text(
                                itemCounter.itemQuantity.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                  //appbar will not disapper
                  pinned: true,
                  //when scroll down star then image will start showing
                  floating: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.12,
                  title: Transform(
                    // you can forcefully translate values left side using Transform
                    transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                    child: Text("title"),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
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
                  ),
                ),
                /*SliverAppBar(
                        //appbar will not disapper
                        pinned: true,
                        //when scroll down star then image will start showing
                        floating: true,
                        expandedHeight: 110,
                        title: Text("title"),
                        flexibleSpace: Container(
                          decoration: const ContainerDecoration().decoaration(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20, bottom: 5, top: 10),
                                child: TextFormField(
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
                                        borderSide: BorderSide.none),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      //color: Colors.cyan,
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
                            ],
                          ),
                        ),
                      ),*/
                SliverToBoxAdapter(
                  child: Padding(
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
                          autoPlay: true,
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
                  ),
                ),
                StreamBuilder(
                  // stream: getDataFromFirebase()!.snapshots(),
                  // stream: FirebaseFirestore.instance.collection("sellers").snapshots(),
                  stream: query3,
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
                        : /*SliverStaggeredGrid.countBuilder(
                              //if SliverStaggeredGrid show wrong then use
                              // flutter_staggered_grid_view: ^0.4.1 in pubspec.yaml
                              itemCount: snapshot.data!.docs.length,
                              crossAxisCount: 1,
                              staggeredTileBuilder: (c) =>
                                  const StaggeredTile.fit(1),
                              itemBuilder: (context, index) {
                                Sellers sModel = Sellers.frmJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);
                                return !snapshot.hasData
                                    ? SliverToBoxAdapter(
                                        child: Center(
                                          child: LoadingContainer(),
                                        ),
                                      )
                                    : SellerProfileDesign(
                                        sellerModel: sModel,
                                        context: context,
                                      );
                              },
                            );*/

                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                print(
                                    " 1 model.isOnline = ${model.isOnline} + JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");
                                Sellers sModel = Sellers.frmJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);
                                return /*!snapshot.hasData
                                      ? CircularProgressIndicator()
                                      : */
                                    SellerProfileDesign(
                                  sellerModel: sModel,
                                  context: context,
                                  netValue: model.isOnline,
                                );
                              },
                              childCount: snapshot.data!.docs.length,
                            ),
                          );

                    /* SliverToBoxAdapter(
                        //listview.bulder needs to calculate size of widget for erver index if you 
                        //use srink. for avoiding this need SliverList
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                // shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Sellers sModel = Sellers.frmJson(
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>);
                                  return /*!snapshot.hasData
                                      ? CircularProgressIndicator()
                                      : */
                                      Container(
                                    height:
                                        MediaQuery.of(context).size.height * 0.4,
                                    width: MediaQuery.of(context).size.width,
                                    child: SellerProfileDesign(
                                      sellerModel: sModel,
                                      context: context,
                                    ),
                                  );
                                },
                              ),
                            );*/
                  },
                ),
              ],
            );

            /*: NoInternet();*/
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
