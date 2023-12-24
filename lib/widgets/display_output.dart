import 'package:cortex/constants/constants.dart';
import 'package:flutter/material.dart';

class DisplayOutput extends StatelessWidget {
  const DisplayOutput({
    super.key,
    required this.regressionType,
    this.output,
  });

  final RegressionType regressionType;
  final dynamic output;

  @override
  Widget build(BuildContext context) {

    // result for currencyClassification
    if(regressionType == RegressionType.currencyClassification) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Class : ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 4,),
              Expanded(
                child: Text(
                  '₹ ${output?[0]['label']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Confidence : ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 4,),
              Expanded(
                child: Text(
                  '${(output?[0]['confidence'] * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // result for OCR
    else {
      return Text(
        '$output',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.right,
      );
    }
  }
}
