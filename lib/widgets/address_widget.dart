import 'package:flutter/material.dart';
import 'package:foodfair/models/address_model.dart';
import 'package:foodfair/providers/address_changer_provider.dart';
import 'package:provider/provider.dart';
import '../global/color_manager.dart';
import '../global/map.dart';
import '../screens/placed_order_screen.dart';

class AddressWidget extends StatefulWidget {
  final AddressModel? addressModel;
  final int? currentAddressIndex;
   final int? index; //value
  // final String? addressID;
  // final double? totalAmount;
   AddressWidget({
    Key? key,
    this.addressModel,
     this.currentAddressIndex,
     this.index,
    // this.addressID,
    // this.totalAmount,
  }) : super(key: key);

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<SellerProvider>(context);
    return InkWell(
      onTap: () {
        //select this address
        Provider.of<AddressChangerProvider>(context, listen: false).getRadioButtonIndex(widget.index);
      },
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentAddressIndex,
                  value: widget.index!,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    //provider
                    // Provider.of<AddressProvider>(context, listen: false)
                    //     .displayResult(val);
                    Provider.of<AddressChangerProvider>(context, listen: false).getRadioButtonIndex(val);
                  },
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text(
                                "Name:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.addressModel!.name.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Phone number:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.addressModel!.phoneNumber.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Flat number:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.addressModel!.flatNumber.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "City:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.addressModel!.city.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "State:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.addressModel!.state.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Full address:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.addressModel!.fullAddress.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                //MapsUtils.openMapWithPosition(widget.addressModel!.latitude!,
                //    widget.addressModel!.longitude!);
                MapsUtils.openMapWithAddress(widget.addressModel!.fullAddress!);
              },
              child: Text(
                "Check on Maps",
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple[300],
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: ColorManager.depOrange1),
                ),
              ),
            ),
            widget.index == Provider.of<AddressChangerProvider>(context).radioButtonIndex
                ? ElevatedButton(
              onPressed: () {
                //Navigator.pushNamed(context, PlacedOrderScreen.path, arguments: widget.addressID);
                // String? sellerUid =  Provider.of<SellerProvider>(context, listen: false)
                //   .sellerUID;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlacedOrderScreen(
                          addressID: widget.addressModel!.addressID,
                        )));
              },
              child: const Text(
                "Proceed",
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple[300],
                padding: const EdgeInsets.symmetric(
                    horizontal: 43, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: ColorManager.depOrange1),
                ),
              ),
            )
                : Text(""),
          ],
        ),
      ),
    );
  }
}