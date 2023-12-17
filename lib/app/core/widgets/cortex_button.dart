import 'package:flutter/material.dart';

class CortexButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color bgColor;
  final double width;
  final double height;

  const CortexButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.bgColor = Colors.black54,
    this.width = 120.0,
    this.height = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width *0.03),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: size.width *0.04, color: Colors.white),
        ),
      ),
    );
  }
}
