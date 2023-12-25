import 'package:cortex/constants/constants.dart';
import 'package:flutter/material.dart';

class CortexFlatButton extends StatelessWidget {
  const CortexFlatButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final Function() onTap;
  final String label;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width *0.8,
        alignment: Alignment.center,
        padding:
        EdgeInsets.symmetric(horizontal: width *0.1, vertical: width *0.04),
        decoration: BoxDecoration(
            color: AppColors.cortexFg,
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: width *0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
