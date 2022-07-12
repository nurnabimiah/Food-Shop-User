import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodfair/global/add_item_to_cart.dart';
import 'package:foodfair/models/order_model.dart';
import 'package:foodfair/screens/user_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodfair/providers/order_provider.dart';
import 'package:foodfair/widgets/container_decoration.dart';
import '../global/color_manager.dart';
import '../global/global_instance_or_variable.dart';
import '../providers/cart_provider.dart';

class PlacedOrderScreen extends StatefulWidget {
  //static final String path = "/PlacedOrderScreen";
  String? addressID;

  PlacedOrderScreen({
    Key? key,
    this.addressID,
  }) : super(key: key);

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  late CartProvider _cartProvider;
  late OrderProvider _orderProvider;
  bool _init = true;
  void didChangeDependencies(){
    if(_init){
      _cartProvider = Provider.of<CartProvider>(context);
      _orderProvider = Provider.of<OrderProvider>(context);
      _orderProvider.getOrderConstants();

    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            decoration: ContainerDecoration().decoaration(),
            child: Column(
              children: [
                Image.asset("assets/images/delivery.png"),
                ElevatedButton(
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[300],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: ColorManager.depOrange1),
                    ),
                  ),
                  onPressed: () async {
                    previousSellerId = '';

                    DateTime timestamp =  DateTime.now();;
                    String orderId = timestamp.millisecondsSinceEpoch.toString();
                    final _orderModel = OrderModel(
                      addressID: widget.addressID,
                      totalAmount: _cartProvider.cartItemsTotalPrice,
                      orderBy: sPref!.getString("uid"),
                      paymentMethod: '',
                      orderTime: timestamp.toIso8601String(),
                      isSuccess: true,
                      sellerUID: _cartProvider.cartModelList[0].sellerId,
                      riderUID: "",
                      status: "normal",
                      orderId: orderId,
                      deliveryCharge: int.parse('${_orderProvider.orderConstantsModel.deliveryCharge}'),
                      vat: int.parse('${_orderProvider.orderConstantsModel.vat}'),
                      discount: int.parse('${_orderProvider.orderConstantsModel.discount}'),
                    );

                    // for(int i = 0; i<_orderModel.productIDs.length; i++){
                    //   print("0 + productList = ${_orderModel.productIDs[i]} + AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                    // }

                    await Provider.of<OrderProvider>(context, listen: false)
                        .addOrder(_orderModel, _cartProvider.cartModelList).then((value){
                        _cartProvider.clearCart();
                        previousSellerId = '';
                        _cartProvider.itemIdAndQuantity = ['-1', '1'];
                         // orderId = '';
                         // Navigator.pushNamed(context, UserHomeScreen.path);
                          Fluttertoast.showToast(
                              msg: "Congratulations, Order has been placed successfully.");
                    });
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
