import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:foodappusers/authentication/auth_screen.dart';
import 'package:foodappusers/global/global.dart';
import 'package:foodappusers/model/seller_model.dart';
import 'package:foodappusers/model/user_model.dart';
import 'package:foodappusers/widgets/app_app_bar.dart';
import 'package:foodappusers/widgets/error_dialog.dart';
import 'package:foodappusers/widgets/seller_design.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static String id = "homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [
    "assets/slider/0.jpg",
    "assets/slider/1.jpg",
    "assets/slider/2.jpg",
    "assets/slider/3.jpg",
    "assets/slider/4.jpg",
    "assets/slider/5.jpg",
    "assets/slider/6.jpg",
    "assets/slider/7.jpg",
    "assets/slider/8.jpg",
    "assets/slider/9.jpg",
    "assets/slider/10.jpg",
    "assets/slider/11.jpg",
    "assets/slider/12.jpg",
    "assets/slider/13.jpg",
    "assets/slider/14.jpg",
    "assets/slider/15.jpg",
    "assets/slider/16.jpg",
    "assets/slider/17.jpg",
    "assets/slider/18.jpg",
    "assets/slider/19.jpg",
    "assets/slider/20.jpg",
    "assets/slider/21.jpg",
    "assets/slider/22.jpg",
    "assets/slider/23.jpg",
    "assets/slider/24.jpg",
    "assets/slider/25.jpg",
    "assets/slider/26.jpg",
    "assets/slider/27.jpg",
  ];

  kikOutBlockedUsers() async {
    final navigator = Navigator.of(context);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        final userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        if (userModel.status == "not approved") {
          FirebaseAuth.instance.signOut();
          navigator.pushNamedAndRemoveUntil(AuthScreen.id, (route) => false);
          showDialog(
              context: context,
              builder: (c) => const ErrorDialog(
                  message:
                      "You are blocked from Admin \n Contact on: admin@gmail.com"));
        }
      }
    });
  }

  @override
  void initState() {
    kikOutBlockedUsers();
    print(sharedPreferences!.getString("uid"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppAppBar(title: "iFood"),
        drawer: const AppDrawer(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  items: items.map((e) {
                    return Builder(
                        builder: (context) => Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(e, fit: BoxFit.cover))));
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.3,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("sellers").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const Center(child: CircularProgressIndicator())
                    : MasonryGridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1),
                        itemBuilder: (context, index) {
                          SellerModel sellerModel = SellerModel.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          return SellerDesign(sellerModel: sellerModel);
                        });
              },
            )
          ],
        ));
  }
}
