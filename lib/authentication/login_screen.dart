import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodappusers/model/user_model.dart';

import '../mainscreen/home_screen.dart';
import '../global/global.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  void _formValidation() {
    if (emailCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty) {
      signinUserWithEmail();
    } else {
      showDialog(
          context: context,
          builder: (c) => const ErrorDialog(
              message: "Please write the complete required Info"));
    }
  }

  void signinUserWithEmail() async {
    showDialog(
        context: context,
        builder: (c) => const LoadingDialog(message: "Login to Your Account"));

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailCtrl.text.trim(), password: passwordCtrl.text.trim())
          .then((auth) {
        _readAndSetDataLocally(auth.user!);
      }).catchError((onError) {
        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (c) => ErrorDialog(message: onError.message.toString()));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future _readAndSetDataLocally(User user) async {
    final navigator = Navigator.of(context);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        final userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        if (userModel.status == "approved") {
          await sharedPreferences!.setString("uid", userModel.userUID);
          await sharedPreferences!.setString("name", userModel.userName);
          await sharedPreferences!.setString("email", userModel.userEmail);
          await sharedPreferences!
              .setString("photoURL", userModel.userPhotoURL);
          await sharedPreferences!.setStringList(
              "userCart", snapshot.data()!["userCart"].cast<String>());
          navigator.pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (c) => const ErrorDialog(
                  message:
                      "You are blocked from Admin \n Contact on: admin@gmail.com"));
          FirebaseAuth.instance.signOut();
        }
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) => const ErrorDialog(
                message: "You don't have permission to login"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 275,
              width: 275,
              child: Image.asset("assets/images/login.png"),
            ),
            CustomTextField(
                controller: emailCtrl,
                iconData: Icons.email,
                hintText: "Enter Your E-Mail"),
            CustomTextField(
                controller: passwordCtrl,
                iconData: Icons.password,
                hintText: "Enter Your Password",
                isObsecure: true),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: CustomButton(
                  onPressed: () => _formValidation(),
                  text: "Sign In",
                  color: Colors.cyan,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
