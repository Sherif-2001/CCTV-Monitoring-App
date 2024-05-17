import 'package:flutter/material.dart';

class AlertTextField extends StatelessWidget {
  const AlertTextField(
      {super.key, required this.controller, required this.hintText,required this.keyboardType});

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
