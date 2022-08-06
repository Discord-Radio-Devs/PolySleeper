import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff201f47),
        colorScheme: ColorScheme(
            primary: Colors.green[300]!,
            primaryContainer: Colors.green[600]!,
            secondary: Colors.indigo[600]!,
            secondaryContainer: Colors.deepPurple[800]!,
            surface: const Color(0xff201f47),
            background: const Color(0xff201f47),
            error: Colors.red[400]!,
            onPrimary: Colors.blueGrey[700]!,
            onSecondary: const Color(0xFF323367),
            onSurface: Colors.indigo[400]!,
            onBackground: Colors.indigo[400]!,
            onError: Colors.red[50]!,
            brightness: Brightness.dark),
        textTheme: Theme.of(context)
            .textTheme
            .apply(
              fontFamily: GoogleFonts.nunito().fontFamily,
              displayColor: Colors.indigo[300],
              bodyColor: Colors.indigo,
            )
            .merge(TextTheme(
                headline1: const TextStyle(fontSize: 32, letterSpacing: 0.5),
                headline2: const TextStyle(fontSize: 28),
                headline3: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: Colors.green[300],
                ),
                headline4: GoogleFonts.montserrat(
                  fontSize: 21,
                  color: Colors.deepPurple[400],
                  fontWeight: FontWeight.w300,
                ))),
        iconTheme: IconThemeData(
          color: Colors.blueGrey[700],
        ),
        timePickerTheme: TimePickerThemeData(
            helpTextStyle: TextStyle(color: Colors.indigo[300])),
      ),
      home: const MyHomePage(
        title: 'Poly Sleeper',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
