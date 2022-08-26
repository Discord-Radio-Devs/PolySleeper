import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:polysleeper/models/user.dart';
import 'package:polysleeper/widgets/timeInputPicker.dart';
import 'package:provider/provider.dart';

import '../widgets/schedule.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String newSleepName = '';
  void _createSchedule(BuildContext context) {
    ScheduleModel scheduleModel = ScheduleModel(
        'Late Siesta + ${Random().nextInt(100000)}', [1, 3, 4, 7]);
    Provider.of<UserModel>(context, listen: false).addSchedule(scheduleModel);
  }

  void _addSleepToSchedule(BuildContext context) async {
    String? nameResult = await _createName(context);

    SleepModel? sleepResult;
    if (nameResult == null) return;

    if (!mounted) return;
    Map<String, bool>? toCalulate = await _getTimeInputs(context);

    if (toCalulate == null) return;
    switch (toCalulate.entries
        .where((element) => element.value == false)
        .first
        .key) {
      case 'StartTime':
        if (!mounted) return;
        sleepResult = await _calcStartTime(context, nameResult);
        break;
      case 'Duration':
        if (!mounted) return;
        sleepResult = await _calcDuration(context, nameResult);
        break;
      case 'EndTime':
        if (!mounted) return;
        sleepResult = await _calcEndTime(context, nameResult);
        break;
      default:
        return;
    }

    if (sleepResult == null || !mounted) return;
    Provider.of<UserModel>(context, listen: false)
        .schedules[UserModel.activeName]!
        .add(sleepResult);
    debugPrint(sleepResult.toJson());
  }

  Future<SleepModel?> _calcStartTime(
      BuildContext context, String nameResult) async {
    TimeOfDay? endTimeResult;
    Duration? durationResult;
    var durationTimeOfDay = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'Select Duration'.toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    durationResult = durationTimeOfDay != null
        ? Duration(
            hours: durationTimeOfDay.hour, minutes: durationTimeOfDay.minute)
        : null;
    if (durationResult == null) return null;

    // Calculate Endtime
    endTimeResult = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (endTimeResult == null) return null;

    return SleepModel.calcStartTime(nameResult, endTimeResult, durationResult);
  }

  _calcDuration(BuildContext context, String nameResult) async {
    TimeOfDay? startTimeResult, endTimeResult;

    startTimeResult = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTimeResult == null) return;
    endTimeResult = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (endTimeResult == null) return;
    return SleepModel(nameResult, startTimeResult, endTimeResult);
  }

  Future<SleepModel?> _calcEndTime(
      BuildContext context, String nameResult) async {
    TimeOfDay? startTimeResult;
    Duration? durationResult;

    // Calculate Endtime
    startTimeResult = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTimeResult == null) return null;

    var durationTimeOfDay = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'Select Duration'.toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    durationResult = durationTimeOfDay != null
        ? Duration(
            hours: durationTimeOfDay.hour, minutes: durationTimeOfDay.minute)
        : null;
    if (durationResult == null) return null;

    return SleepModel.calcEndTime(nameResult, startTimeResult, durationResult);
  }

  Future<String?> _createName(BuildContext context) async {
    newSleepName = 'Sleep 😴';

    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    child: Text("Cancel".toUpperCase()),
                    onPressed: () => Navigator.pop(context)),
                TextButton(
                    child: Text("Confirm".toUpperCase()),
                    onPressed: () => Navigator.pop(context, newSleepName))
              ],
              title: const Text("Sleep Name"),
              content: TextFormField(
                initialValue: newSleepName,
                onChanged: (v) => newSleepName = v,
                onEditingComplete: () => Navigator.pop(context, newSleepName),
                textAlign: TextAlign.center,
              ),
            ).build(context));
  }

  Future<Map<String, bool>?> _getTimeInputs(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text('Choose your operators'),
              // actions: [
              //   TextButton(
              //       child: Text("Cancel".toUpperCase()),
              //       onPressed: () => Navigator.pop(context)),
              //   TextButton(
              //       child: Text("Confirm".toUpperCase()),
              //       onPressed: () => Navigator.pop(context, newSleepName))
              // ],
              content: Center(heightFactor: 1, child: TimeInputPicker()),
            ).build(context));
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
            heroTag: 'Add sleep to schedule FAB',
            onPressed: () => _addSleepToSchedule(context),
            tooltip: 'Add sleep to schedule',
            child: const Icon(Icons.bedroom_baby),
          ),
          FloatingActionButton(
            heroTag: 'Create Reminder FAB',
            onPressed: () => _addReminderToSleep(context),
            tooltip: 'Create Reminder',
            child: const Icon(Icons.schedule),
          ),
          FloatingActionButton(
            heroTag: 'Create Schedule FAB',
            onPressed: () => _createSchedule(context),
            tooltip: 'Create Schedule',
            child: const Icon(Icons.calendar_month),
          ),
          FloatingActionButton(
            heroTag: 'Clear Schedule FAB',
            onPressed: () => _clearSchedule(context),
            tooltip: 'Clear Schedule',
            child: const Icon(Icons.delete),
          ),
        ],
      )
    ]);
  }
}
