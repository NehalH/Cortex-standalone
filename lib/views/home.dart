import 'dart:io';
import 'package:cortex/constants/constants.dart';
import 'package:cortex/interpreter/currencyClassifier/currency_classifier.dart';
import 'package:cortex/interpreter/interface.dart';
import 'package:cortex/widgets/cortex_button.dart';
import 'package:cortex/widgets/display_output.dart';
import 'package:cortex/widgets/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isWaitingForInput = true;
  bool _isLoadingModels = true;
  String _status = '';
  bool _isProcessing = false;
  late String _image;
  late List _output;
  RegressionType regressionType = RegressionType.currencyClassification;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera
  final Interpreter _interpreter = CurrencyClassifier();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoadingModels = true;
      _status = 'Loading the Models . . .';
    });
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
        model: 'assets/models/currency_classifier_model/rupee_classifier_quant.tflite',
        labels: 'assets/models/currency_classifier_model/labels.txt',
        // numThreads: 1,
    );
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingModels = false;
      _status = "Finished loading models";
    });
  }

  pickImage() async {
    //this function to grab the image from camera
    var image = await picker.getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxHeight: 224,
      maxWidth: 224,
    );
    if (image == null) return null;

    runThroughModel(image);
  }

  pickGalleryImage() async {
    // this function to grab the image from the gallery
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    runThroughModel(image);
  }

  runThroughModel(var image) async{
    setState(() {
      _image = image.path;
      _status = 'Preprocessing...';
      _isProcessing = true;
    });

    var result = await _interpreter.processImage(_image);

    setState(() {
      _output = result!;
      _isWaitingForInput = false;
      _status = 'Idle';
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: AppColors.cortexPrimaryBg,
        padding: EdgeInsets.symmetric(horizontal: width *0.06, vertical: width *0.06),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(width *0.06),
          decoration: BoxDecoration(
            color: AppColors.cortexSecondaryBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _isWaitingForInput == true
                    ? LoadingStatus(label: _status, isBusy: _isLoadingModels,)
                    : Column(
                      children: [
                        SizedBox(
                          height: width *0.6,
                          width: width *0.6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              File(_image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 25,
                          thickness: 1,
                        ),
                        DisplayOutput(regressionType: regressionType, output: _output,),
                        const Divider(
                          height: 25,
                          thickness: 1,
                        ),
                      ],
                    ),
              ),
              Column(
                children: [
                  CortexFlatButton(
                      label: 'Take A Photo',
                      onTap: pickImage,
                  ),
                  SizedBox(
                    height: width *0.05,
                  ),
                  CortexFlatButton(
                      label: 'Pick From Gallery',
                      onTap: pickGalleryImage,
                  ),
                  SizedBox(
                    height: width *0.08,
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
