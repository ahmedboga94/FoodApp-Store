import 'package:flutter/material.dart';
import '../mainscreen/item_details_screen.dart';
import '../model/item_model.dart';

class ItemDesign extends StatelessWidget {
  final ItemModel itemModel;
  const ItemDesign({super.key, required this.itemModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => ItemDetailsScreen(itemModel: itemModel)))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 290,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
              Image.network(itemModel.itemImageURL,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover),
              const SizedBox(height: 5),
              Text(itemModel.itemTitle,
                  style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "TrainOne")),
              Text(itemModel.itemInfo,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}
