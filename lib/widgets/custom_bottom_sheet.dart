import 'package:fight_nofight/widgets/picker_button.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet(
      {super.key,
      required this.onCameraPressed,
      required this.onGalleryPressed});

  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // The button of the camera
          PickerButton(
              icon: Icons.camera, onPressed: onCameraPressed, text: "Camera"),
          // The button of the gallery
          PickerButton(
              icon: Icons.video_call,
              onPressed: onGalleryPressed,
              text: "Gallery"),
        ],
      ),
    );
  }
}
