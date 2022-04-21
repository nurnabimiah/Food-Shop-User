import 'package:flutter/material.dart';
import 'package:foodfair/Screens/save_address_screen.dart';
import 'package:foodfair/widgets/simple_appbar.dart';

class AddressScreen extends StatefulWidget {
  static final String path = "/AddressScreen";

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppbar(),
      floatingActionButton: SizedBox(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.50,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed(SaveAddressScreen.path);
          },
          label: const Text("Add new address"),
          icon: const Icon(
            Icons.add_location,
            color: Colors.white,
          ),
          backgroundColor: Colors.purple[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //side: const BorderSide(color: Colors.red),
          ),
        ),
      ),
      body: Column(
        children: const[
           Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Select Address",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
