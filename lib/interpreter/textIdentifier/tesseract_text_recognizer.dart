import 'package:cortex/interpreter/interface.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';

class TesseractTextRecognizer extends Interpreter{
  @override
  Future<List> processImage(String imgPath) async {
    final res = await FlutterTesseractOcr.extractText(imgPath, args: {
      "psm": "4",
      "preserve_interword_spaces": "1",
    });
    print("----- Res");
    print(res);
    // return the String as a list with one element
    return [res];
  }
}
