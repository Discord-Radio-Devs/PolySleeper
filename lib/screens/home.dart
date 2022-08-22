import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:polysleeper/models/user.dart';
import 'package:polysleeper/widgets/schedule.dart';
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
        TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 2))),
        TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 1))));

    print(sleepModel.toJson());
    Provider.of<UserModel>(context, listen: false)
        .schedules[UserModel.activeName]!
        .add(sleepModel);
  }

  void _addReminderToSleep(BuildContext context) {
    Provider.of<UserModel>(context, listen: false)
        .schedules[UserModel.activeName]!
        .sleeps
        .last
        .createReminder(const Duration(minutes: 1), "Reminder to go to sleep",
            notiBody: "Bro this is just a reminder");
  }

  _clearSchedule(BuildContext context) {
    Provider.of<UserModel>(context, listen: false).clearSchedules();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

    return Column(children: [
      Text("Bruh has been pressed $_counter times"),
      if (user.schedules[UserModel.activeName] != null)
        // Ok this is a problem. Right now the create fires when the object INSIDE user.schedules[UserModel.activeName] changes
        // So lets say a schedule with name Siesta is added first and becomes active. The create creates a reference to this schedule
        // If the active schedule would change however, the create would still only listen to the Siesta schedule and never notice
        // the content of user.schedules, and thus the active schedule, actually changed

        // TODO: Im too stupid to figure this out, maybe Lancear will help me fix it
        ChangeNotifierProvider<ScheduleModel>(
          create: (context) => user.schedules[UserModel.activeName]!,
          child: const Schedule(),
        )
      else
        const Text("No active schedule found!"),
      // ...user.schedules.values
      //     .map((s) => ChangeNotifierProvider<ScheduleModel>(
      //         create: (context) => s,
      //         child: Padding(
      //             padding: const EdgeInsets.all(4),
      //             child: Consumer<ScheduleModel>(
      //                 builder: (context, ScheduleModel schedule, _) =>
      //                     Text(schedule.toJson())))))
      //     .toList(),
      ButtonBar(
        layoutBehavior: ButtonBarLayoutBehavior.padded,
        children: [
          FloatingActionButton(
            onPressed: () => _addSleepToSchedule(context),
            tooltip: 'Increment2',
            child: const Icon(Icons.bedroom_baby),
          ),
          FloatingActionButton(
            onPressed: () => _addReminderToSleep(context),
            tooltip: 'Create Reminder',
            child: const Icon(Icons.schedule),
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
