import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/providers/cart_provider.dart';
import 'package:foodfair/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import '../global/color_manager.dart';
import '../global/global_instance_or_variable.dart';
import '../widgets/container_decoration.dart';
import 'address_screen.dart';
import 'user_home_screen.dart';

enum FilterOption {
  //assigning label of interger
  Camera,
  Gallery,
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();
  String? completeAddress;
  var imagePath;
  String? userImageUrl;

  bool isLoading = false;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _formvalidationAndSave() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    //_formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    // uploadProfileImage();
    authenticateUserAndSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register form"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const ContainerDecoration().decoaration(),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: LoadingDailog(
                message: "Registering Account",
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: const ContainerDecoration().decoaration(),
              //color: Colors.red,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      formMethod(),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple[300],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: ColorManager.depOrange1),
                          ),
                        ),
                        onPressed: () {
                          _formvalidationAndSave();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  formMethod() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide.none),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.cyan,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "Name",
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter a name";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide.none),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.cyan,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "email",
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "please enter an email";
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
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide.none),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.cyan,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "password",
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "please enter password";
              } else if (value.length < 6) {
                return "password must be at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            obscureText: true,
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide.none),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.cyan,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "confirm password",
            ),
            validator: (value) {
              if (value != passwordController.text) {
                return "passwords do not match";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future authenticateUserAndSignUp() async {
    try {
      //firebaseAuth = thiis variable from global_instance_or_variable file
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        saveDataToFireStore(userCredential.user!).then((value) {
          Navigator.pop(context);
          //send the user to homepage
          final _cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          if (_cartProvider.cartModelList.isEmpty) {
            Navigator.pop(context);
            //Navigator.pop(context);
            Navigator.pushReplacementNamed(context, UserHomeScreen.path);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => UserHomeScreen()));
          } else {
            _cartProvider.addToCartInFirebaseAfterFirstLogin();
            //Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddressScreen()));
          }
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      // if (error.code == 'weak-password') {
      // } else if (error.code == 'email-already-in-use') {}
      _showErrorDialog(error.message!);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      var errMessage = "Could not authenticate.\nPlease try later.";
      _showErrorDialog(errMessage);
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    final _userModel = UserModel(
      userUID: currentUser.uid,
      userEmail: currentUser.email,
      userName: nameController.text.trim(),
      userPhotoUrl: userImageUrl,
    );
    await Provider.of<UserProvider>(context, listen: false)
        .addUser(_userModel, currentUser.uid);
    // final shData = jsonEncode(_userModel);
    //save data locally with sharedPrefernces
    sPref = await SharedPreferences.getInstance();
    //here uid and email come from firebase authectication. because if they are authenticate then
    //all data will store into firbase database
    await sPref!.setString("uid", currentUser.uid);
    await sPref!.setString("email", currentUser.email.toString());
    await sPref!.setString("name", nameController.text.trim());
    //await sPref!.setString("userModel", shData);
  }
}
