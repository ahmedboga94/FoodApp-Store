import 'package:flutter/material.dart';
import 'package:foodappusers/mainscreen/menu_screen.dart';
import 'package:foodappusers/model/seller_model.dart';

class SellerDesign extends StatelessWidget {
  final SellerModel sellerModel;
  const SellerDesign({super.key, required this.sellerModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MenuScreen(sellerModel: sellerModel))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 290,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
              Image.network(sellerModel.sellerPhotoURL,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover),
              const SizedBox(height: 5),
              Text(sellerModel.sellerName,
                  style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "TrainOne")),
              Text(sellerModel.sellerEmail,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}
