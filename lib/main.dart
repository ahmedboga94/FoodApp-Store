import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodappusers/global/default_address_controller.dart';
import 'package:foodappusers/mainscreen/address_screen.dart';
import 'package:foodappusers/mainscreen/cart_screen.dart';
import 'package:foodappusers/mainscreen/history_screen.dart';
import 'package:foodappusers/mainscreen/menu_screen.dart';
import 'package:foodappusers/mainscreen/order_screen.dart';
import 'package:foodappusers/mainscreen/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/cart_controller.dart';
import 'mainscreen/home_screen.dart';
import 'authentication/auth_screen.dart';
import 'global/global.dart';
import 'mainscreen/item_screen.dart';
import 'splashscreen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartController()),
        ChangeNotifierProvider(create: (context) => DefaultAddressController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Food Sales",
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          AuthScreen.id: (context) => const AuthScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          MenuScreen.id: (context) => const MenuScreen(),
          ItemScreen.id: (context) => const ItemScreen(),
          CartScreen.id: (context) => const CartScreen(),
          OrderScreen.id: (context) => const OrderScreen(),
          AddressScreen.id: (context) => const AddressScreen(),
          HistoryScreen.id: (context) => const HistoryScreen(),
          SearchScreen.id: (context) => const SearchScreen(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
