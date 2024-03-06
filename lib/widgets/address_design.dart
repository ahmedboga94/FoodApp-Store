import 'package:flutter/material.dart';
import 'package:foodappusers/global/default_address_controller.dart';
import 'package:foodappusers/mainscreen/placed_order_screen.dart';
import 'package:foodappusers/maps/maps.dart';
import 'package:foodappusers/model/address_model.dart';
import 'package:foodappusers/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddressDesign extends StatelessWidget {
  final AddressModel addressModel;
  final int? currentIndex, value;
  final String? addressID, sellerUID;
  final double? totalAmount;

  const AddressDesign(
      {super.key,
      required this.addressModel,
      this.currentIndex,
      this.value,
      this.addressID,
      this.sellerUID,
      this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Provider.of<DefaultAddressController>(context, listen: false)
          .displayResult(value),
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            RadioListTile(
                value: value,
                groupValue: currentIndex,
                activeColor: Colors.amber,
                title:
                    Text("${addressModel.city}, ${addressModel.gavernorate}"),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(addressModel.completeAddress),
                      Text(addressModel.phoneNumber),
                    ]),
                onChanged: (val) => Provider.of<DefaultAddressController>(
                        context,
                        listen: false)
                    .displayResult(val)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 99),
                child: CustomButton(
                    onPressed: () => MapsUtils.openMapWithPosition(
                        addressModel.lat, addressModel.lng),
                    text: "Check on Maps",
                    color: Colors.black54)),
            totalAmount != null
                ? value == Provider.of<DefaultAddressController>(context).count
                    ? CustomButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacedOrderScreen(
                                        addressID: addressID!,
                                        sellerUID: sellerUID!,
                                        totalAmount: totalAmount!.toDouble(),
                                      )));
                        },
                        text: "Proceed",
                        color: Colors.green)
                    : const SizedBox()
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
