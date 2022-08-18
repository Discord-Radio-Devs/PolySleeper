import 'package:flutter/material.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:polysleeper/models/user.dart';
import 'package:polysleeper/widgets/scrollablesafehaven.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  get counter => _counter;

  void _incrementCounter(BuildContext context) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });

    ScheduleModel scheduleModel = ScheduleModel('Late Siesta', [1, 3, 4, 7]);
    SleepModel sleepModel = SleepModel(
        'Nap',
        TimeOfDay.fromDateTime(DateTime.now()),
        TimeOfDay.fromDateTime(
            DateTime.now().add(const Duration(minutes: 30))));
    scheduleModel.add(sleepModel);
    print(scheduleModel.toJson());
  }

  void _incrementCounter2(BuildContext context) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
    SleepModel sleepModel = SleepModel(
        'Nap',
        TimeOfDay.fromDateTime(DateTime.now()),
        TimeOfDay.fromDateTime(
            DateTime.now().add(const Duration(minutes: 30))));

    print(sleepModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

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
        body: ScrollableSafeHaven(
          children: user.schedules.entries
              .map((s) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(s.value.toJson())))
              .toList(),
        ),
        floatingActionButton: ButtonBar(
          children: [
            FloatingActionButton(
              onPressed: () => _incrementCounter(context),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: () => _incrementCounter2(context),
              tooltip: 'Increment2',
              child: const Icon(Icons.check),
            ),
          ],
        ));
  }
}
