import 'package:flutter/material.dart';
import 'package:foodfair/providers/item_counter_provider.dart';
import 'package:foodfair/widgets/cart_widget.dart';
import 'package:foodfair/widgets/text_widget_header.dart';
import 'package:provider/provider.dart';
import '../global/color_manager.dart';
import '../providers/cart_provider.dart';
import '../widgets/container_decoration.dart';
import 'address_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider _cartProvider;
  late ItemCounterProvider _itemCounterProvider;
  double _totalAmount = 0;
  bool _init = true;

  //didChangeDependencies always will be called when data will change and it also rebuilds
  //ui.  but initState may not be called though data will change and it may not rebuild ui.
  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _itemCounterProvider = Provider.of<ItemCounterProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (

          ){},
            icon: Icon(Icons.arrow_back),),
          title: const Text("foods"),
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
                Positioned(
                  top: 3,
                  right: 10,
                  child: Text(
                    _cartProvider.cartModelList.length.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                )
              ],
            ),
          ],
        ),
        floatingActionButton: _cartProvider.cartModelList.isEmpty
            ? null
            : floatingActionButtonMethod(),
        body: _cartProvider.cartModelList.isEmpty
            ? Center(
                child: Text(
                  "Not yet added in cart",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
              )
            : customScrollViewMetho());
  }

  customScrollViewMetho() {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _cartProvider.totalItemsInCart == 0
              ? TextWidgetHeader(title: "Total price = Tk 0")
              : TextWidgetHeader(
                  title:
                      "Total price = Tk ${_cartProvider.cartItemsTotalPrice}"),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                _totalAmount = 0;
                _totalAmount = _totalAmount +
                    (_cartProvider.cartModelList[index].price! *
                        _cartProvider.cartModelList[index].quantity);
              } else {
                _totalAmount = _totalAmount +
                    (_cartProvider.cartModelList[index].price! *
                        _cartProvider.cartModelList[index].quantity);
              }

              return CartWidget(
                cartModel: _cartProvider.cartModelList[index],
                quantity: _cartProvider.cartModelList[index].quantity,
                total: _totalAmount,
              );
            },
            childCount: _cartProvider
                .cartModelList.length, /* ? snapshot.data!.docs.length : 0*/
          ),
        ),
      ],
    );
  }

  floatingActionButtonMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 36,
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                onPressed: () {
                  _cartProvider.clearCart();
                  _itemCounterProvider.setItemCounterOne();
                },
                label: const Text(
                  "Clear cart",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                backgroundColor: ColorManager.purple2,
                icon: const Icon(Icons.clear_all),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: 36,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              onPressed: () {
                Navigator.of(context).pushNamed(AddressScreen.path);
              },
              label: const Text(
                "Check Out",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              backgroundColor: ColorManager.purple2,
              icon: const Icon(Icons.navigate_next),
            ),
          ),
        ),
      ],
    );
  }
}
