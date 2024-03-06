import 'package:flutter/material.dart';
import 'package:foodappusers/mainscreen/item_screen.dart';
import 'package:foodappusers/model/menu_model.dart';

class MenuDesign extends StatelessWidget {
  final MenuModel menuModel;
  const MenuDesign({super.key, required this.menuModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ItemScreen(menuModel: menuModel))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 290,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
              Image.network(menuModel.menuImageURL,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover),
              const SizedBox(height: 5),
              Text(menuModel.menuTitle,
                  style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "TrainOne")),
              Text(menuModel.menuInfo,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}
