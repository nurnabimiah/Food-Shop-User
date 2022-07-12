import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/providers/cart_provider.dart';
import 'package:foodfair/providers/user_provider.dart';
import 'package:foodfair/screens/address_screen.dart';
import 'package:foodfair/screens/auth_screen.dart';
import 'package:foodfair/screens/cart_screen.dart';
import 'package:foodfair/screens/save_address_screen.dart';
import 'package:foodfair/providers/order_provider.dart';
import 'package:foodfair/providers/sellers_provider.dart';
import 'package:foodfair/screens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/address_changer_provider.dart';
import 'providers/address_provider.dart';
import 'providers/internet_connectivity.dart';
import 'screens/splash_screen.dart';
import 'global/global_instance_or_variable.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //what is for dont know. have to know
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //though I made sPref as global why here is needed. dont know
  sPref = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InternetConnectivityProvider(),
          //child: const UserHomeScreen(),
        ),
        ChangeNotifierProvider(create: (context) => SellersProvider()),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (context)=> CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context)=> AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (context)=> AddressChangerProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodfair',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      //initialRoute: SplashScreen(),
      routes: {
        SplashScreen.path: (context)=> SplashScreen(),
        AddressScreen.path: (context) => AddressScreen(),
        SaveAddressScreen.path: (context) => SaveAddressScreen(),
        UserHomeScreen.path: (context) => UserHomeScreen(),
        CartScreen.path: (context) => CartScreen(),
        AuthScreen.path: (context)=> AuthScreen(),
        //PlacedOrderScreen.path: (context) => PlacedOrderScreen(),
      },
    );
  }
}