import 'package:camera/camera.dart';
import 'package:cortex/widgets/cortex_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Page', style: TextStyle(color: Colors.white70),),
        backgroundColor: Colors.black87,
        elevation: 0,

      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(picture.path), fit: BoxFit.cover, width: size.width *0.6),
          SizedBox(height: size.height *0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CortexButton(label: 'Currency', onPressed: (){}),
              SizedBox(width: size.width *0.02,),
              CortexButton(label: 'OCR', onPressed: (){}),
            ],
          )
        ]),
      ),
    );
  }
}
