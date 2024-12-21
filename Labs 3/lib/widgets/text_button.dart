import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String? tooltip;
  final String text;
  final void Function()? onPressed;

  const CustomTextButton({super.key, required this.text, this.tooltip, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: Colors.blue[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints.tightFor(
        width: 400,
        height: 60,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
