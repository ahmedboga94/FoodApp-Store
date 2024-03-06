import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappusers/global/cart_functions.dart';
import 'package:foodappusers/global/global.dart';
import 'package:foodappusers/model/order_model.dart';
import 'package:foodappusers/widgets/app_app_bar.dart';
import 'package:foodappusers/widgets/custom_button.dart';

class PlacedOrderScreen extends StatefulWidget {
  final String addressID, sellerUID;
  final double totalAmount;

  const PlacedOrderScreen(
      {super.key,
      required this.addressID,
      required this.sellerUID,
      required this.totalAmount});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderID = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails() {
    final orderModel = OrderModel(
      orderBy: sharedPreferences!.getString("uid")!,
      paymentDetails: "Cash on Delivery",
      orderID: orderID,
      sellerUID: widget.sellerUID,
      driverID: "",
      isSuccess: true,
      productsIDs: sharedPreferences!.getStringList("userCart")!,
      orderTime: Timestamp.now(),
      addressID: widget.addressID,
      totalAmount: widget.totalAmount,
      status: "normal",
    );

    writeOrderDetailsForUser(orderModel.toJson());
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderID)
        .set(data)
        .then((value) {
      FirebaseFirestore.instance.collection("orders").doc(orderID).set(data);
    }).whenComplete(() {
      CartFunctions.clearCartNow(context, "Order Placed Successfully");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "View Order", isCart: false),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.amber,
            Colors.cyan,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.0, 1.0],
        )),
        child: Column(
          children: [
            const Spacer(flex: 5),
            Image.asset("assets/images/delivery.jpg"),
            const Spacer(flex: 1),
            CustomButton(
                onPressed: () => addOrderDetails(),
                text: "Place Order",
                color: Colors.green),
            const Spacer(flex: 15),
          ],
        ),
      ),
    );
  }
}
