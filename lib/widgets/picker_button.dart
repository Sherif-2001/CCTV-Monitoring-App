import 'package:flutter/material.dart';

class PickerButton extends StatelessWidget {
  const PickerButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.text});

  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        Text(text)
      ],
    );
  }
}
