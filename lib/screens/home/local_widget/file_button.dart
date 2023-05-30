import 'package:flutter/material.dart';

import '../../../constants.dart';

class FileButton extends StatelessWidget {
  const FileButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.width, // Add width parameter
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;
  final double? width; // Define width parameter

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Set the width of the button
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Constants.Kprimary),
        ),
        label: label,
      ),
    );
  }
}
