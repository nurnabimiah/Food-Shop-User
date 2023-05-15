import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'auth_screen.dart';
import 'user_home_screen.dart';
import '../global/global_instance_or_variable.dart';

class SplashScreen extends StatefulWidget {
  static final String path = "/splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {


  bool selected = false;

  startTimer() {
    Timer(const Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserHomeScreen())
          // context, MaterialPageRoute(builder: (context) => UserHomeScreen())
      );
    });
  }


  Future startAnimation() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      selected = true;

    });
  }


  @override
  void initState() {
    super.initState();
    startAnimation().then((value) => startTimer());

  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   startTimer();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: [
            AnimatedPositioned(
              curve: Curves.linear,

              top: selected?200:400,
              left: selected?71:18,
              width: selected ? 217 : 323,
              height: selected ? 217 : 323,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Ink(child: Center(child: Lottie.asset('assets/animations/delivery-rider.json'))),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text('Food Shop',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.red),),
                  ),

                ],
              ),
              duration: const Duration(seconds: 1),
            )
          ],
        )
    );

  }
}
