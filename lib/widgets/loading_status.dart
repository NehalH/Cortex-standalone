import 'package:cortex/constants/constants.dart';
import 'package:flutter/material.dart';

class LoadingStatus extends StatefulWidget {
  const LoadingStatus({super.key, required this.label, required this.isBusy});

  final String label;
  final bool isBusy;

  @override
  State<LoadingStatus> createState() => _LoadingStatusState();
}

class _LoadingStatusState extends State<LoadingStatus> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: width *0.6,
          width: width *0.6,
          alignment: Alignment.center,
          padding: EdgeInsets.all(width *0.06),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(widget.isBusy)
                Transform.scale(
                  scale: 0.8,
                  child: const CircularProgressIndicator(),
                ),
              SizedBox(height: width *0.05,),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: width *0.04,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: width *0.05,)
      ],
    );
  }
}
