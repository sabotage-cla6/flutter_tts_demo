import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-TTS Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter-TTS Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextEditingController? speechRateFieldController = TextEditingController();
  TextEditingController? speechPitchFieldController = TextEditingController();

  String _voiceName = "Microsoft Ayumi";
  FlutterTts tts = FlutterTts();
  List<Map<String, String>> voices = [
    {"name": "Microsoft Ayumi", "locale": "ja-JP"},
    {"name": "Microsoft Haruka", "locale": "ja-JP"},
    {"name": "Microsoft Ichiro", "locale": "ja-JP"},
  ];

  @override
  void initState() {
    super.initState();
    _init_tts();
  }

  void _init_tts() async {
    // await tts.setLanguage('ja-JP');
    // await tts.setSpeechRate(0.6);
    // await tts.setPitch(1.0);
    await tts.awaitSpeakCompletion(false); // 発話の完了まで待機。
    await tts.setVoice({"name": "Microsoft Ayumi", "locale": "ja-JP"});
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = (++_counter % voices.length);
      _voiceName = voices[_counter]["name"]!;
    });
    tts.setVoice(voices[_counter]);
    Future<Set<dynamic>> stop() async => {await tts.stop()};
    stop();
    speak();
  }

  void speak() async {
    await tts.speak('''
サブチャンネル MJで麻雀入門
MJで麻雀入門のチャンネルでは麻雀初心者向けに
麻雀のルール
打ちかたの基本
などを解説しています。
まだはじめたばかりのチャンネルですが、よろしくおねがいします。
''');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            ListView(
              shrinkWrap: true, // 追加
              children: [
                Wrap(
                  children: [
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(10),
                      child: DropdownButton(
                        items: const [
                          DropdownMenuItem(child: Text('Microsoft Ayumi'), value: 'Microsoft Ayumi'),
                          DropdownMenuItem(child: Text('Microsoft Haruka'), value: 'Microsoft Haruka'),
                          DropdownMenuItem(child: Text('Microsoft Ichiro'), value: 'Microsoft Ichiro'),
                        ],
                        onChanged: (String? value) {
                          setState(() {});
                        },
                        value: _voiceName,
                      ),
                    ),
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(labelText: "声の高さ"),
                        controller: speechRateFieldController,
                      ),
                    ),
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(labelText: "声の速度"),
                        controller: speechPitchFieldController,
                      ),
                    ),
                  ],
                ),
                Text('$_voiceName'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            //
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
