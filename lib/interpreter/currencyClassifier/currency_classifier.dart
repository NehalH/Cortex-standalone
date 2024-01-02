import 'dart:io';

import 'package:cortex/interpreter/interface.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class CurrencyClassifier extends Interpreter {
  @override
  Future<List> processImage(String imgPath) async {
    return classifyImage(File(imgPath));
  }

  Future<List> classifyImage(File image) async {
    // this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.0,  // TODO: Increase threshold and handle null
      imageMean: 225.0,
      imageStd: 225.0,
    );
    return output ?? [];
  }
}
