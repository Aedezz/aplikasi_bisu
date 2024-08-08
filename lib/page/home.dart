import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController textC = TextEditingController();
  stt.SpeechToText speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Bisu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textC,
              decoration: InputDecoration(
                labelText: "Ketik pesan anda",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await flutterTts.speak(textC.text);
              },
              child: Text("Bicara"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startListening() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      speech.listen(onResult: (val) {
        setState(() {
          textC.text = val.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }
}