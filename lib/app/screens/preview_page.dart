import 'package:camera/camera.dart';
import 'package:cortex/app/core/widgets/cortex_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);
  final XFile picture;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late Future<String> inferResult;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Page', style: TextStyle(color: Colors.white70)),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(widget.picture.path), fit: BoxFit.cover, width: size.width * 0.6),
            SizedBox(height: size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CortexButton(label: 'Currency', onPressed: () {}),
                SizedBox(width: size.width * 0.02),
                CortexButton(label: 'OCR', onPressed: () {}),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            // Use a FutureBuilder to display the result or a circular progress indicator
            FutureBuilder<String>(
              future: inferResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a circular progress indicator while waiting for the result
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle errors
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Display the result when available
                  return Text('Inference Result: ${snapshot.data}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
