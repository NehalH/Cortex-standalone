import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class RupeeClassifier {
    static loadModel() async {
        // Get the number of available processors
        // int maxThreads = Platform.numberOfProcessors;

        var interpreter = await TfliteFlutter.loadModel(
            model: 'assets/models/currency_classifier/rupee_classifier_quant.tflite',
            labels: 'assets/models/currency_classifier/labels.txt',
            // numThreads: maxThreads,
            // useGpuDelegate: true,
        );
        return interpreter;
    }

    static infer(XFile file) async {
        var inference = await TfliteFlutter.runModelOnImage(
            path: file.path,
            numResults: 2,
            threshold: 0.5,
            imageMean: 127.5,
            imageStd: 127.5,
        );
        await releaseResources();
        return inference;
    }

    static releaseResources() async {
        await TfliteFlutter.close();
        return;
    }
}
