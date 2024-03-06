import 'package:flutter/material.dart';
import 'package:foodappusers/global/cart_controller.dart';
import 'package:foodappusers/mainscreen/cart_screen.dart';
import 'package:provider/provider.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCart;
  const AppAppBar({super.key, required this.title, this.isCart = true});
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
        ))),
        title: Text(title,
            style: const TextStyle(fontFamily: "Signatra", fontSize: 40)),
        centerTitle: true,
        actions: isCart == false
            ? []
            : [
                Consumer<CartController>(
                  builder: (context, countControl, child) => IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, CartScreen.id),
                    icon: Badge(
                      label: Text(countControl.count.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      textColor: Colors.white,
                      backgroundColor: Colors.cyan,
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                )
              ]);
  }
}
