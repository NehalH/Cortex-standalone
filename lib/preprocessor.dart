import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';

img.Image preprocessImage(File imageFile) {
  // // Read the image file
  // var image = img.decodeImage(imageFile.readAsBytesSync())!;
  //
  // // Set parameters for preprocessing
  // int inputSize = 224;
  // double mean = 127.5;
  // double std = 127.5;
  //
  // // Create a new Image object with resized dimensions
  // var resizedImage = img.copyResize(image, width: inputSize, height: inputSize);
  //
  // // Initialize the Uint8List directly from resizedImage
  // var convertedBytes = Uint8List.fromList(resizedImage.getBytes());
  //
  // return img.Image.fromBytes(inputSize, inputSize, convertedBytes);

  var image = decodeImage(imageFile.readAsBytesSync());
  return copyResize(image!, width: 224, height: 224);
}
