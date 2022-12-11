import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:record_mp3/record_mp3.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpeechPrep',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Poppins",
        scaffoldBackgroundColor: const Color(0x263238ff),
      ),
      home: const MyHomePage(title: "",),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Image.asset('assets/SpeechPrep.png', scale: 2),
            SizedBox(height: 90),
            const Text(
              'SpeechPrep',
              style: TextStyle(fontSize: 28.0, color:Colors.white, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20),
            const Text(
              'Analyze and Improve your speaking skills with the power of AI',
              style: TextStyle(fontSize: 12.0, color:Colors.white, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 180),
            Container(
              alignment: const Alignment(0, 0.7),
              child: FlatButton(
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20.0),
                ),
                color: const Color(0xFF5667FD),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyStatefulWidget()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  static const List<Widget> _widgetOptions = <Widget>[
    MyCustomForm(),
    Text(
      'Analyze',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpeechPrep'),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF5667FD),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analyze',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          return getVoice();
        });
  }

  Future<String> callAsyncFetch() async {
    return "hi";
  }

  Widget getVoice() {
    final _formKey = GlobalKey<FormState>();
    int i = 0;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {

                  if (_formKey.currentState!.validate()) {
                    i += 1;
                    if(i > 1) {
                      RecordMp3.instance.stop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recording Stopped')),
                      );
                      var request = http.MultipartRequest('POST', Uri.parse("https://SpeechPrep-API.neeltron.repl.co"));
                      request.files.add(await http.MultipartFile.fromPath("file", "/storage/emulated/0/Download/alpha.mp3"));
                      var response =await request.send();
                      print(response);
                    }
                    else {
                      RecordMp3.instance.start("/storage/emulated/0/Download/alpha.mp3", (type) {
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recording Started')),
                      );
                    }
                  }

                },
                child: const Icon(Icons.mic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
