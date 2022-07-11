import 'package:flutter/material.dart';
import 'package:foodfair/providers/cart_provider.dart';
import 'package:foodfair/screens/my_order_screen.dart';
import 'package:foodfair/screens/user_home_screen.dart';
import 'package:foodfair/global/global_instance_or_variable.dart';
import 'package:provider/provider.dart';

import '../global/color_manager.dart';
import '../screens/auth_screen.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late CartProvider _cartProvider;
  double? size;

  void didChangeDependencies() async {
    _cartProvider = Provider.of<CartProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("object = ${sPref!.getString("photoUrl")}");
    size = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            color: ColorManager.amber1,
            child: Column(
              children: [
                sPref!.getString("photoUrl") == null
                    ? Text('')
                    : Material(
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        elevation: 10,
                        child: Container(
                          width: size! * 0.2,
                          height: size! * 0.2,
                          // height: 160,
                          // width: 160,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage("${sPref!.getString("photoUrl")}"),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                sPref!.getString("name") == null
                    ? Text('')
                    : Text(
                        "${sPref!.getString("name")}",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                const SizedBox(
                  height: 10,
                ),
                sPref!.getString("email") == null
                    ? Text('')
                    : Text(
                        "${sPref!.getString("email")}",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            height: 0,
            color: Colors.cyan,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserHomeScreen()));
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.reorder),
            title: const Text(
              'Orders',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyOrderSceen()));
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text(
              'History',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text(
              'Search',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.add_location),
            title: const Text(
              'Add new address',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () async {
              firebaseAuth.signOut().then((value) async {
                sPref!.setString("uid", '');
                await sPref!.setString("photoUrl", '');
                await sPref!.setString("name", '');
                await sPref!.setString("email", '');

                // await sPref!.setString("uid", currentUser.uid);
                // await sPref!.setString("email", currentUser.email.toString());
                // await sPref!.setString("name", nameController.text.trim());
                // await sPref!.setString("photoUrl", userImageUrl!);
                print("loagut ");

                _cartProvider.cartModelList.clear();
                _cartProvider.clearCart().then((value) {
                  print("loagut 2");
                  print(
                      "carlist.lengt = ${_cartProvider.cartModelList.length}");
                  Navigator.pushNamed(context, UserHomeScreen.path);

                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserHomeScreen()));
                });

                // Navigator.pushReplacement(context, MaterialPageRoute(
                //     builder: (context) => AuthScreen()));
              });
            },
          ),
        ],
      ),
    );
  }
}
