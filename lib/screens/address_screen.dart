import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair/providers/address_changer_provider.dart';
import 'package:foodfair/providers/address_provider.dart';
import 'package:foodfair/widgets/progress_bar.dart';
import 'package:foodfair/widgets/address_widget.dart';
import 'package:provider/provider.dart';
import '../models/address_model.dart';
import 'save_address_screen.dart';

class AddressScreen extends StatefulWidget {
  static final String path = "/AddressScreen";

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late AddressProvider _addressProvider;
  late AddressChangerProvider _addressChangerProvider;
  bool _init = true;
  bool _isLoading = true;

  void didChangeDependencies() async {
    _addressProvider = Provider.of<AddressProvider>(context);
    _addressChangerProvider = Provider.of<AddressChangerProvider>(context);
    if (_init) {
      // _addressChangerProvider.getRadioButtonIndex(0);
      await _addressProvider.fetchUserAllAddress().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Shop"),
        centerTitle: true,
      ),
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
          backgroundColor: Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //side: const BorderSide(color: Colors.red),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _addressProvider.addressNumber == 0
                    ? Text('')
                    : const Align(
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
                Flexible(
                  child: ListView.builder(

                      itemCount: _addressProvider.addressModellist.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        print("indxe screen = $index");
                        return AddressWidget(
                          currentAddressIndex:
                              _addressChangerProvider.radioButtonIndex,
                          index: index,
                          addressModel:
                              _addressProvider.addressModellist[index],
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
