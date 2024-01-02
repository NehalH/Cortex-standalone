import 'dart:io';
import 'package:cortex/constants/constants.dart';
import 'package:cortex/interpreter/currencyClassifier/currency_classifier.dart';
import 'package:cortex/interpreter/interface.dart';
import 'package:cortex/interpreter/textIdentifier/tesseract_text_recognizer.dart';
import 'package:cortex/tts/tts.dart';
import 'package:cortex/widgets/cortex_button.dart';
import 'package:cortex/widgets/display_output.dart';
import 'package:cortex/widgets/loading_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late String? _image;
  late dynamic _output = '';
  late Interpreter _interpreter;
  late RegressionType regressionType;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    setState(() {
      _image = null;
      _isLoadingModels = true;
      _status = 'Loading the Models . . .';

      // set default interpreter as Currency classifier
      regressionType = RegressionType.currencyClassification;
      _interpreter = CurrencyClassifier();
    });
    loadModel().then((value) {
      setState(() {});
    });
    TextToSpeech.init();
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  loadModel() async {
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

  changeInterpreter() {
    regressionType == RegressionType.ocr
      ? _interpreter = TesseractTextRecognizer()
      : _interpreter = CurrencyClassifier();
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
    setState(() {
      _image = image.path;
    });

    runThroughModel();
  }

  pickGalleryImage() async {
    // this function to grab the image from the gallery
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = image.path;
    });
    runThroughModel();
  }

  runThroughModel() async{

    var result = await _interpreter.processImage(_image!);

    setState(() {
      if(result == [] || result == ''){
        _output = "Could not identify the object.";
      }
      else{
        _output = result;
      }
      _isWaitingForInput = false;
      _status = 'Idle';
    });

    TextToSpeech.speak(result, regressionType);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: AppColors.cortexPrimaryBg,
        padding: EdgeInsets.symmetric(horizontal: width *0.04, vertical: width *0.04),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: width *0.04, horizontal: width *0.03),
          decoration: BoxDecoration(
            color: AppColors.cortexSecondaryBg,
            borderRadius: BorderRadius.circular(width *0.02),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cortexFg,
                  borderRadius: BorderRadius.circular(width *0.02),
                ),
                padding: EdgeInsets.symmetric(vertical: width *0.02, horizontal: width *0.02),
                child: Row(
                  children: [
                    Text(
                      'CORTEX',
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: width *0.06,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: width *0.01, horizontal: width *0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black26,
                          ),
                          child: Text(
                            regressionType == RegressionType.ocr
                                ?'Text Identification'
                                :'Currency Classification',
                            style: TextStyle(
                              fontSize: width *0.035,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(width: width *0.01,),
                        Transform.scale(
                          scale: 0.9,
                          child: CupertinoSwitch(
                            trackColor: Colors.amber,
                            activeColor: Colors.blue,
                            value: regressionType == RegressionType.ocr,
                            onChanged: (value) {
                              setState(() {
                                if(_output != "Processing..."){
                                  _output = "Processing...";
                                  regressionType = value ? RegressionType.ocr : RegressionType.currencyClassification;
                                  changeInterpreter();
                                  if(_image != null) {
                                    runThroughModel();
                                  }
                                  else {
                                    _output = "";
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(height: width *0.05,),
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
                              File(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: width *0.06,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(width *0.02),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: width *0.1, vertical: width *0.05),
                          child: Center(
                            child: DisplayOutput(regressionType: regressionType, output: _output,),
                          ),
                        ),
                        SizedBox(height: width *0.06,),
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
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
