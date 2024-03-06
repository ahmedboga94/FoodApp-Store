import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodappusers/global/global.dart';
import 'package:foodappusers/model/address_model.dart';
import 'package:foodappusers/widgets/app_app_bar.dart';
import 'package:foodappusers/widgets/custom_button.dart';
import 'package:foodappusers/widgets/custom_text_field.dart';
import 'package:foodappusers/widgets/error_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _city = TextEditingController();
  final _gavernorate = TextEditingController();
  final _completeAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double lat = 0.0;
  double lng = 0.0;

  _getCurrentLocation(BuildContext context) async {
    List<Placemark> placeMakers;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      placeMakers = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      lat = position.altitude;
      lng = position.longitude;

      Placemark pMark = placeMakers[0];
      _city.text = pMark.locality!;
      _gavernorate.text = pMark.administrativeArea!;
      _completeAddress.text =
          "${pMark.thoroughfare!}, ${pMark.subThoroughfare!}, ${pMark.street}";
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 1), () {
        showDialog(
            context: context,
            builder: (c) =>
                const ErrorDialog(message: "Permission not granted"));
      });
    }
  }

  _addAddressToFireBase(BuildContext context) async {
    final addAddress = AddressModel(
        name: _name.text.trim(),
        phoneNumber: _phoneNumber.text.trim(),
        city: _city.text.trim(),
        gavernorate: _gavernorate.text.trim(),
        completeAddress: _completeAddress.text.trim(),
        lat: lat,
        lng: lng);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("addresses")
        .doc()
        .set(addAddress.toJson())
        .then((value) {
      showToast("Address is added successfully", context: context);
      Navigator.pop(context);
    });
  }

  _formValidation(BuildContext context) {
    if (_name.text.isNotEmpty &&
        _phoneNumber.text.isNotEmpty &&
        _city.text.isNotEmpty &&
        _gavernorate.text.isNotEmpty &&
        _completeAddress.text.isNotEmpty) {
      _addAddressToFireBase(context);
    } else {
      showDialog(
          context: context,
          builder: (c) => const ErrorDialog(
              message: "Please write the complete required Info"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Add New Address", isCart: false),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.amber,
            Colors.cyan,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.0, 1.0],
        )),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                      controller: _name,
                      iconData: Icons.person,
                      hintText: "Enter Your Name"),
                  CustomTextField(
                      controller: _phoneNumber,
                      iconData: Icons.phone,
                      hintText: "Enter Your Phone"),
                  CustomTextField(
                      controller: _gavernorate,
                      iconData: Icons.location_on,
                      hintText: "Enter Your Gavernorate"),
                  CustomTextField(
                      controller: _city,
                      iconData: Icons.location_city,
                      hintText: "Enter Your City"),
                  CustomTextField(
                      controller: _completeAddress,
                      iconData: Icons.location_history,
                      hintText: "Add Additonal Details"),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: CustomButton(
                          onPressed: () => _getCurrentLocation(context),
                          text: "Get my current Location",
                          icon: true,
                          color: Colors.amber)),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 50,
                    child: CustomButton(
                      onPressed: () => _formValidation(context),
                      text: "Add Address",
                      color: Colors.cyan,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
