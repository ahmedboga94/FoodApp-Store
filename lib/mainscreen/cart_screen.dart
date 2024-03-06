import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodappusers/global/cart_controller.dart';
import 'package:foodappusers/global/cart_functions.dart';
import 'package:foodappusers/mainscreen/address_screen.dart';
import 'package:foodappusers/model/item_model.dart';
import 'package:foodappusers/widgets/app_app_bar.dart';
import 'package:foodappusers/widgets/cart_item_design.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static String id = "cartScreen";
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    num totalAmount = 0;
    String sellerUID = "";
    return Scaffold(
      appBar: const AppAppBar(title: "Cart", isCart: false),
      floatingActionButton: Consumer<CartController>(
        builder: (context, cartAmount, child) => cartAmount.count != 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 7),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                          heroTag: "clearAll",
                          onPressed: () => CartFunctions.clearCartNow(
                              context, "Cart is empty now"),
                          label: const Text("Clear Cart",
                              style: TextStyle(fontSize: 16)),
                          backgroundColor: Colors.cyan,
                          icon: const Icon(Icons.clear_all))),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                          heroTag: "goToCheck",
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddressScreen(
                                        totalAmount: totalAmount.toDouble(),
                                        sellerUID: sellerUID,
                                      ))),
                          label: const Text("Check Out",
                              style: TextStyle(fontSize: 16)),
                          backgroundColor: Colors.cyan,
                          icon: const Icon(Icons.next_week_outlined)))
                ],
              )
            : const SizedBox(),
      ),
      body: Column(
        children: [
          Consumer<CartController>(
            builder: (context, cartAmount, child) => cartAmount.count == 0
                ? const SizedBox()
                : Column(
                    children: [
                      ListTile(
                          title: Text("Total Amount = ${cartAmount.tAmount}\$",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: "Signatra",
                                  fontSize: 30,
                                  color: Colors.cyan,
                                  letterSpacing: 3))),
                      const Divider(thickness: 2),
                    ],
                  ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .where("itemID", whereIn: CartFunctions.separateItemIDs())
                  .orderBy("publishedData", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.data!.docs.isEmpty
                        ? const Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.remove_shopping_cart_outlined,
                                      size: 150, color: Colors.cyan),
                                  Text("No Items in Cart.",
                                      style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ]),
                          )
                        : MasonryGridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (context, index) {
                              final itemModel = ItemModel.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);

                              if (index == 0) {
                                totalAmount = totalAmount +
                                    (itemModel.itemPrice *
                                        CartFunctions.separateItemQtys()[
                                            index]);
                                Future.microtask(() => context
                                    .read<CartController>()
                                    .displayTotalAmount(
                                        totalAmount.toDouble()));
                              } else {
                                totalAmount = totalAmount +
                                    (itemModel.itemPrice *
                                        CartFunctions.separateItemQtys()[
                                            index]);

                                Future.microtask(() => context
                                    .read<CartController>()
                                    .displayTotalAmount(
                                        totalAmount.toDouble()));
                              }
                              sellerUID = itemModel.sellerUID;
                              // if (snapshot.data!.docs.length - 1 == index) {
                              //   Future.microtask(() => context
                              //       .read<CartController>()
                              //       .displayTotalAmount(
                              //           totalAmount.toDouble()));
                              // }

                              return CartItemDesign(
                                  itemModel: itemModel,
                                  sperateItemQty:
                                      CartFunctions.separateItemQtys()[index]);
                            });
              },
            ),
          ),
        ],
      ),
    );
  }
}
