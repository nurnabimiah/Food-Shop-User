import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/Screens/address_screen.dart';
import 'package:foodfair/Screens/save_address_screen.dart';
import 'package:foodfair/providers/cart_item_quantity_provider.dart';
import 'package:foodfair/providers/total_amount_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/user_home_screen.dart';
import 'providers/internet_connectivity_provider.dart';
import 'Screens/splash_screen.dart';
import 'global/global_instance_or_variable.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //what is for dont know. have to know
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //though I made sPref as global why here is needed. dont know
  sPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InternetConnectivityProvider(),
          child: const UserHomeScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartItemQuanityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TotalAmountProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Foodfair',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  SplashScreen(),
        //initialRoute: SplashScreen(),
        routes: {
          AddressScreen.path:(context) => AddressScreen(),
          SaveAddressScreen.path:(context) => SaveAddressScreen(),
        },
      ),
    );
  }
}
