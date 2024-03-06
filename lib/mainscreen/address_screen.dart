import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodappusers/global/default_address_controller.dart';
import 'package:foodappusers/global/global.dart';
import 'package:foodappusers/mainscreen/add_address_screen.dart';
import 'package:foodappusers/model/address_model.dart';
import 'package:foodappusers/widgets/address_design.dart';
import 'package:foodappusers/widgets/app_app_bar.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  static String id = "addressScreen";

  final double? totalAmount;
  final String? sellerUID;
  const AddressScreen({super.key, this.totalAmount, this.sellerUID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Your Address", isCart: false),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.cyan,
          label: const Text("Add New Address"),
          icon: const Icon(Icons.add_location),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddAddressScreen(),
              ))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Select Address:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Consumer<DefaultAddressController>(
            builder: (context, address, child) => Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("addresses")
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator())
                      : snapshot.data!.docs.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Icon(Icons.block,
                                      size: 150, color: Colors.cyan),
                                  Text(
                                      "No Addressess is added, Tap on Add New Address",
                                      style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ])
                          : MasonryGridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1),
                              itemBuilder: (context, index) {
                                final addressModel = AddressModel.fromJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);
                                return AddressDesign(
                                  addressModel: addressModel,
                                  currentIndex: address.count,
                                  value: index,
                                  addressID: snapshot.data!.docs[index].id,
                                  totalAmount: totalAmount,
                                  sellerUID: sellerUID,
                                );
                              });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
