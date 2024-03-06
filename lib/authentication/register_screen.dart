import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodappusers/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../mainscreen/home_screen.dart';
import '../global/global.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();

  String userImageURL = "";

  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();

  void _getImage() async {
    imageXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> _formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) => const ErrorDialog(message: "Please select an Image"));
    } else {
      if (passwordCtrl.text == confirmPasswordCtrl.text) {
        if (userNameCtrl.text.isNotEmpty &&
            emailCtrl.text.isNotEmpty &&
            passwordCtrl.text.isNotEmpty &&
            confirmPasswordCtrl.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) =>
                  const LoadingDialog(message: "Registering Your Account"));
          autanticateSellerAndSignUp();
        } else {
          showDialog(
              context: context,
              builder: (c) => const ErrorDialog(
                  message: "Please write the complete required Info"));
        }
      } else {
        showDialog(
            context: context,
            builder: (c) => const ErrorDialog(message: "Password don't match"));
      }
    }
  }

  void autanticateSellerAndSignUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailCtrl.text.trim(), password: passwordCtrl.text.trim())
          .then((auth) {
        saveUserDataToFirestore(auth.user!).then((value) =>
            Navigator.of(context).pushReplacementNamed(HomeScreen.id));
      }).catchError((onError) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (c) => ErrorDialog(message: onError.message.toString()));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future saveUserDataToFirestore(User currentUser) async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child("users").child(fileName);
    UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    userImageURL = await taskSnapshot.ref.getDownloadURL();

    final userModel = UserModel(
        status: "approved",
        userName: userNameCtrl.text.trim(),
        userEmail: currentUser.email.toString(),
        userUID: currentUser.uid,
        userPhotoURL: userImageURL,
        userCart: ["garbageValue"]);

    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .set(userModel.toJson());
    //save data locally
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", userNameCtrl.text.trim());
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!.setString("photoURL", userImageURL);
    await sharedPreferences!.setStringList("userCart", ["garbageValue"]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () => _getImage(),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.19,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(File(imageXFile!.path)),
                  child: imageXFile == null
                      ? Icon(Icons.add_a_photo,
                          size: MediaQuery.of(context).size.width * 0.19,
                          color: Colors.grey)
                      : null,
                )),
            CustomTextField(
                controller: userNameCtrl,
                iconData: Icons.person,
                hintText: "Enter Your Name"),
            CustomTextField(
                controller: emailCtrl,
                iconData: Icons.email,
                hintText: "Enter Your E-Mail"),
            CustomTextField(
                controller: passwordCtrl,
                iconData: Icons.password,
                hintText: "Enter Your Password",
                isObsecure: true),
            CustomTextField(
                controller: confirmPasswordCtrl,
                iconData: Icons.password,
                hintText: "Confim Your Password",
                isObsecure: true),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: CustomButton(
                onPressed: () => _formValidation(),
                text: "Sign Up",
                color: Colors.cyan,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
