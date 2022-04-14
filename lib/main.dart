import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      providers:[
        ChangeNotifierProvider(
          create: (context) => InternetConnectivityProvider(),
          child: UserHomeScreen(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Foodfair',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
