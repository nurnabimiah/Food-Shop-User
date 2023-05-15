import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/models/items_model.dart';
import 'package:foodfair/screens/address_screen.dart';
import 'package:foodfair/screens/cart_screen.dart';
import 'package:foodfair/screens/user_items_details_screen.dart';
import 'package:foodfair/screens/user_items_screen.dart';
import 'package:foodfair/widgets/add_and_remove_into_cart_widget.dart';
import 'package:foodfair/widgets/app_input_decoration/app_input_decoration.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_dialog.dart';
import '../../global/global_instance_or_variable.dart';
import '../../widgets/container_decoration.dart';
import '../global/color_manager.dart';
import '../providers/cart_provider.dart';
import 'registration_screen.dart';
import 'user_home_screen.dart';

class AuthScreen extends StatefulWidget {
  static final String path = "/authScreen";

  // ItemModel? itemModel;
  // double? buttonSize;
  //String? fromCartScreen;
  //
  // AuthScreen({this.fromCartScreen});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();

  late CartProvider _cartProvider;
  String? fromCartScreen;

  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    fromCartScreen = ModalRoute.of(context)!.settings.arguments.toString();
    super.didChangeDependencies();
  }

  _formValidation() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    login();
  }

  Future login() async {
    showDialog(
      context: context,
      builder: (context) {
        return LoadingDailog(
          message: "Authentication Checking.",
        );
      },
    );

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController!.text.trim(),
      password: passwordController!.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      readDataAndSaveDataLocally(currentUser!);
    }
  }

//by this function user id is going to store on the using device
  Future readDataAndSaveDataLocally(User currentUser) async {
    //FirebaseFirestore.instance.collection('riders').doc(currentUser.uid).get() = we are retreiving
    //the current user data from Firebase Database uder users collection and store data into
    //snapShot
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((snapShot) async {
      //if users data has come and not is equal to null or is exist.
      if (snapShot.data() != null) {
        //currentUser.uid = this come from Authentication
        await sPref!.setString("uid", currentUser.uid);
        //snapshot.data()![""] = all comes from FireStore Database
        await sPref!.setString("email", snapShot.data()!["userEmail"]);
        await sPref!.setString("name", snapShot.data()!["userName"]);

        //from firestore the data come as dynamic so here need to be casted
        // List<String> userCartList = snapShot.data()!["userCart"].cast<String>();
        // await sPref!.setStringList("userCart", userCartList);

        // Navigator.pop(context);
        print("user id = ${sPref!.getString("uid")}");
        if (sPref!.getString("uid") != '' && fromCartScreen == "fromCartScreen") {
          _cartProvider.addToCartInFirebaseAfterFirstLogin();
          //Navigator.pushNamed(context, AddressScreen.path);
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CartScreen()));
        } else {
          print("I an in sign in user auth screen");
          Navigator.pop(context);
          //Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => UserHomeScreen()));
         // Navigator.pushNamed(context, UserHomeScreen.path);
        }
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                message:
                    "There is no user record corresponding to this identifier. The user may have been deleted.",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.only(left: 16.0,right: 16,top: 200,bottom: 100),
        child: SingleChildScrollView(
          child: Column(

            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Lottie.asset('assets/animations/132642-fast-food.json',fit: BoxFit.fitWidth),
                    Text('Food Shop',style: TextStyle(fontSize: 32,color: Colors.red,fontWeight: FontWeight.w600),),

                    SizedBox(height: 30,),

                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: appInputDecoration('Email',Icon(Icons.email,color: Colors.white,)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter an email";
                        } else if (!value.contains('@')) {
                          return "Invalid email";
                        }
                        return null;
                      },
                    ),



                    const SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: appInputDecoration('Password',Icon(Icons.lock,color: Colors.white,)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        } else if (value.length < 6) {
                          return "password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),



                    const SizedBox(
                      height: 30,
                    ),

                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        child: const Text(
                          "Sing In",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.red,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: ColorManager.depOrange1),
                          ),
                        ),
                        onPressed: () {
                          _formValidation();
                        },
                      ),
                    ),

                  ],
                ),
              ),



              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not yet to account ?'),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RegistrationScreen()));
                  }, child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color: Colors.red),))
                ],
              )





            ],
          ),
        ),
      ),
    );
  }
}
