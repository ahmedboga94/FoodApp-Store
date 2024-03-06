import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodappusers/model/menu_model.dart';
import 'package:foodappusers/model/seller_model.dart';
import 'package:foodappusers/widgets/app_app_bar.dart';
import 'package:foodappusers/widgets/app_drawer.dart';
import '../widgets/menu_design.dart';

class MenuScreen extends StatefulWidget {
  static String id = "menuScreen";
  final SellerModel? sellerModel;
  const MenuScreen({super.key, this.sellerModel});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "iFood"),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          ListTile(
              title: Text("${widget.sellerModel!.sellerName}'s Menus",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: "Signatra",
                      fontSize: 40,
                      color: Colors.cyan,
                      letterSpacing: 3))),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(widget.sellerModel!.sellerUID)
                  .collection("menus")
                  .orderBy("publishedData", descending: true)
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
                                Text("No Menus here, Please try again later.",
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
                              MenuModel menuModel = MenuModel.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);
                              return MenuDesign(menuModel: menuModel);
                            });
              },
            ),
          ),
        ],
      ),
    );
  }
}
