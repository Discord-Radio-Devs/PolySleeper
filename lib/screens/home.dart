import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:polysleeper/models/user.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state yay. It holds the values (in this
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
      _counter++;
      throw Exception("Your mommy");
    });
  }

  void _createSchedule(BuildContext context) {
    ScheduleModel scheduleModel = ScheduleModel(
        'Late Siesta + ${Random().nextInt(100000)}', [1, 3, 4, 7]);
    Provider.of<UserModel>(context, listen: false).addSchedule(scheduleModel);
  }

  void _addSleepToSchedule(BuildContext context) {
    SleepModel sleepModel = SleepModel(
        'Nap',
        TimeOfDay.fromDateTime(DateTime.now()),
        TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 1))));

    print(sleepModel.toJson());
    Provider.of<UserModel>(context, listen: false)
        .schedules
        .values
        .last
        .add(sleepModel);
  }

  _clearSchedule(BuildContext context) {
    Provider.of<UserModel>(context, listen: false).clearSchedules();
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
    return Column(children: [
      Text("Bruh has been pressed $_counter times"),
      ...user.schedules.values
          .map((s) => ChangeNotifierProvider(
              create: (context) => s,
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Consumer(
                      builder: (context, ScheduleModel schedule, _) =>
                          Text(schedule.toJson())))))
          .toList(),
      ButtonBar(
        children: [
          FloatingActionButton(
            onPressed: () => _incrementCounter(context),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () => _addSleepToSchedule(context),
            tooltip: 'Increment2',
            child: const Icon(Icons.bedroom_baby),
          ),
          FloatingActionButton(
            onPressed: () => _createSchedule(context),
            tooltip: 'Create Schedule',
            child: const Icon(Icons.calendar_month),
          ),
          FloatingActionButton(
            onPressed: () => _clearSchedule(context),
            tooltip: 'Clear Schedule',
            child: const Icon(Icons.delete),
          ),
        ],
      )
    ]);
  }
}
