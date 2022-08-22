import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:polysleeper/models/user.dart';
import 'package:provider/provider.dart';

import '../widgets/schedule.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
        ChangeNotifierProvider<ScheduleModel>.value(
          value: user.schedules[UserModel.activeName]!,
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
