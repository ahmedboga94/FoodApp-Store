import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final bool icon;
  final Color color;
  final double fontSize;
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.icon = false,
      required this.color,
      this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon == true ? const Icon(Icons.location_on) : const SizedBox(),
            Text(text,
                style: TextStyle(color: Colors.white, fontSize: fontSize)),
          ],
        ),
      ),
    );
  }
}
