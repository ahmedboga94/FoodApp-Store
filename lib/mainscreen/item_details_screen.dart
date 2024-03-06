import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodappusers/global/cart_controller.dart';
import 'package:foodappusers/global/cart_functions.dart';
import 'package:foodappusers/global/global.dart';
import 'package:foodappusers/model/item_model.dart';
import 'package:foodappusers/widgets/app_app_bar.dart';
import 'package:provider/provider.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ItemModel itemModel;
  const ItemDetailsScreen({super.key, required this.itemModel});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController qtyController = TextEditingController();
  int _counterValue = 1;

  _addToCart(String itemID, int qtyNum, BuildContext context) {
    List<String>? tempList = sharedPreferences!.getStringList("userCart");
    tempList!.add("$itemID:$qtyNum");

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({"userCart": tempList}).then((value) {
      showToast("Item was added successfully", context: context);
      sharedPreferences!.setStringList("userCart", tempList);
      Provider.of<CartController>(context, listen: false)
          .displayCartListItemsNum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppAppBar(title: widget.itemModel.itemTitle),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.itemModel.itemImageURL,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text(widget.itemModel.itemTitle,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 22),
              Text("Price    ${widget.itemModel.itemPrice} \$",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              Text(widget.itemModel.itemDescription,
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 140,
          padding: const EdgeInsets.only(bottom: 20, top: 4, right: 8, left: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: ListTile(
                      title: Text("Total Counted Price: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                        "\$",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      height: 55,
                      width: 150,
                      child: CounterButton(
                          loading: false,
                          onChange: (int val) {
                            setState(() {
                              if (val >= 1) _counterValue = val;
                            });
                          },
                          count: _counterValue,
                          countColor: Colors.cyan)),
                  SizedBox(
                    width: 180,
                    height: 55,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan),
                        icon:
                            const Icon(Icons.shopping_bag, color: Colors.amber),
                        label: const Text("Add to Cart",
                            style: TextStyle(color: Colors.amber)),
                        onPressed: () {
                          List<String> seperateItemsList =
                              CartFunctions.separateItemIDs();
                          seperateItemsList.contains(widget.itemModel.itemID)
                              ? showToast("Item is already in Cart",
                                  context: context)
                              : _addToCart(widget.itemModel.itemID,
                                  _counterValue, context);
                        }),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
