import 'package:flutter/material.dart';
import 'package:foodappusers/global/global.dart';

class CartController extends ChangeNotifier {
  int _cartListItemCounter =
      sharedPreferences!.getStringList("userCart")!.length - 1;
  int get count => _cartListItemCounter;

  double totalAmount = 0;
  double get tAmount => totalAmount;

  void displayCartListItemsNum() {
    _cartListItemCounter =
        sharedPreferences!.getStringList("userCart")!.length - 1;
    notifyListeners();
  }

  displayTotalAmount(double number) async {
    totalAmount = number;

    notifyListeners();
  }
}
