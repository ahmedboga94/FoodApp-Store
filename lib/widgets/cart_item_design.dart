import 'package:flutter/material.dart';
import 'package:foodappusers/model/item_model.dart';

class CartItemDesign extends StatelessWidget {
  final ItemModel itemModel;
  final int sperateItemQty;
  const CartItemDesign(
      {super.key, required this.itemModel, required this.sperateItemQty});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(itemModel.itemImageURL,
                  width: 140, height: 120, fit: BoxFit.cover),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(itemModel.itemTitle,
                      style: const TextStyle(
                          fontFamily: "KiwiMaru",
                          fontSize: 18,
                          color: Colors.black)),
                  Text("x ${sperateItemQty.toString()}",
                      style: const TextStyle(
                          fontFamily: "Acme",
                          fontSize: 25,
                          color: Colors.black)),
                  Text("Price: ${itemModel.itemPrice.toString()} \$",
                      style: const TextStyle(
                          fontFamily: "Acme",
                          fontSize: 25,
                          color: Colors.black)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
