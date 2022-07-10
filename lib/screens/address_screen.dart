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
  void didChangeDependencies()async{
    _addressProvider = Provider.of<AddressProvider>(context);
    _addressChangerProvider = Provider.of<AddressChangerProvider>(context, listen: false);
    if(_init){
      await _addressProvider.fetchUserAllAddress();
    }
    _init = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: SimpleAppbar(title: "foodfair",),
      appBar: AppBar(
        title: Text("foodfair"),
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
      body: Column(
        children: [
          const Align(
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
              child: StreamBuilder(
                stream: _addressProvider.queryAddress,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  return !snapshot.hasData
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                AddressModel? addressModel = AddressModel.fromMap(
                                  snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>,
                                );
                                return AddressWidget(
                                   currentAddressIndex: _addressChangerProvider.radioButtonIndex,
                                   index: index,
                                  // addressID: snapshot.data!.docs[index].id,
                                  // totalAmount: tAmount.totalAmount,
                                  addressModel: addressModel,
                                );
                              });
                },
              ),
            ),
        ],
      ),
    );
  }
}
