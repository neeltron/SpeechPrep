import 'dart:io';
import 'dart:convert';
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
  void initState() {
    super.initState();
    Future<Album> futureAlbum = fetchAlbum();
  }
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
  static final List<Widget> _widgetOptions = <Widget>[
    const MyCustomForm(),
    getRequest(),
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

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://SpeechPrep-API.neeltron.repl.co/analyze'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String text;
  final String mistakes;
  final String sentiment_overall;
  final String sentiment_individual;
  final String safety;
  final String score;
  const Album({
    required this.text,
    required this.mistakes,
    required this.sentiment_overall,
    required this.sentiment_individual,
    required this.safety,
    required this.score
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      text: json['text'],
      mistakes: json['mistakes'],
      sentiment_overall: json['sentiment'],
      sentiment_individual: json['individual'],
      safety: json['safety_labels'],
      score: json['score']
    );
  }
}

Widget getRequest() {
  final _formKey = GlobalKey<FormState>();
  Future<Album> futureAlbum = fetchAlbum();
  return FutureBuilder<Album>(    future: futureAlbum,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Align(alignment: Alignment.center, child: Text("Speech Report", textAlign: TextAlign.center, style: const TextStyle(fontSize: 24.0, color:Colors.green, fontFamily: 'Poppins'),),),
                  Text("Speech Score: " + snapshot.data!.score + " / 10", style: const TextStyle(fontSize: 16.0, color:Colors.green, fontFamily: 'Poppins'),),
                  Text("Transcribed Text: " + snapshot.data!.text, style: const TextStyle(fontSize: 14.0, color:Colors.white, fontFamily: 'Poppins'),),
                  Text("Grammatical Errors:", style: const TextStyle(fontSize: 16.0, color:Colors.green, fontFamily: 'Poppins'),),
                  Text(snapshot.data!.mistakes, style: const TextStyle(fontSize: 14.0, color:Colors.red, fontFamily: 'Poppins'),),
                  Text("How your speech sounds to listeners:", style: const TextStyle(fontSize: 16.0, color:Colors.green, fontFamily: 'Poppins'),),
                  Text("Overall: " + snapshot.data!.sentiment_overall, style: const TextStyle(fontSize: 14.0, color:Colors.white, fontFamily: 'Poppins'),),
                  Text("Individually: " + snapshot.data!.sentiment_individual, style: const TextStyle(fontSize: 14.0, color:Colors.white, fontFamily: 'Poppins'),),
                  Text("Warning: You have mentioned the following in your speech-", style: const TextStyle(fontSize: 16.0, color:Colors.red, fontFamily: 'Poppins'),),
                  Text(snapshot.data!.safety, style: const TextStyle(fontSize: 14.0, color:Colors.white, fontFamily: 'Poppins'),),

              ],
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }

// By default, show a loading spinner.
      return const CircularProgressIndicator();
    },
  );
}
