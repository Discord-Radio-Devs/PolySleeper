import 'package:flutter/material.dart';
import 'package:polysleeper/widgets/sleep.dart';
import 'package:provider/provider.dart';

import '../models/schedule.dart';
import '../models/sleep.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ScheduleModel schedule, child) {
        return Column(children: [
          Row(children: [Text(schedule.name)]),
          Row(
              children: ["M", "T", "W", "T", "F", "S", "S"]
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(entry.value,
                          style: schedule.weekdays.contains(entry.key + 1)
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary))))
                  .toList()),
          ...schedule.sleeps
              .where((sleep) =>
                  sleep.startTime.hour * 60 + sleep.startTime.minute >
                  TimeOfDay.now().hour * 60 + TimeOfDay.now().minute)
              .map((s) => ChangeNotifierProvider<SleepModel>.value(
                  value: s,
                  child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Sleep(
                        schedule: schedule,
                      )))),
          ...schedule.sleeps
              .where((sleep) =>
                  sleep.startTime.hour * 60 + sleep.startTime.minute <=
                  TimeOfDay.now().hour * 60 + TimeOfDay.now().minute)
              .map((s) => ChangeNotifierProvider<SleepModel>.value(
                  value: s,
                  child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Sleep(
                        schedule: schedule,
                      )))),
        ]);
      },
    );
  }
}
