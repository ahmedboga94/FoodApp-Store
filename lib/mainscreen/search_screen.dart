import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappusers/model/seller_model.dart';
import 'package:foodappusers/widgets/seller_design.dart';

class SearchScreen extends StatefulWidget {
  static String id = "searchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? resturantDocList;
  String sellerNameText = "";

  initSearchingRestaurant(String value) async {
    resturantDocList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isLessThanOrEqualTo: value)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
        ))),
        title: TextField(
          onChanged: (value) {
            setState(() {});
            sellerNameText = value;
            initSearchingRestaurant(value);
          },
          decoration: InputDecoration(
            hintText: "Search Restaurant...",
            border: InputBorder.none,
            // style: const TextStyle(color: Colors.white,fontSize: 15),
            suffixIcon: IconButton(
              onPressed: () {
                initSearchingRestaurant(sellerNameText);
              },
              icon: const Icon(Icons.search),
              color: Colors.white,
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      body: FutureBuilder(
        future: resturantDocList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    SellerModel sellerModel = SellerModel.fromJson(
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>);
                    return SellerDesign(sellerModel: sellerModel);
                  },
                )
              : const Center(child: Text("No Data found"));
        },
      ),
    );
  }
}
