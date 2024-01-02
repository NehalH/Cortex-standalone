import 'package:cortex/constants/constants.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static final FlutterTts flutterTts = FlutterTts();
  static speak(dynamic text, RegressionType type) async{
    if(type == RegressionType.currencyClassification){
      await flutterTts.speak('Currency Identified:  ${text[0]['label']} Rupees');
    }
    else{
      await flutterTts.speak('$text');
    }
  }

  static init() async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.0);
  }

  static stop() async{
    await flutterTts.stop();
  }
}