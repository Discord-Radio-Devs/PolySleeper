import 'package:flutter/material.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:polysleeper/widgets/reminder.dart';

class SleepDetailsPage extends StatefulWidget {
  final SleepModel sleep;
  const SleepDetailsPage({Key? key, required this.sleep}) : super(key: key);

  @override
  State<SleepDetailsPage> createState() => _SleepDetailsPageState();
}

class _SleepDetailsPageState extends State<SleepDetailsPage> {
  _onAddPressed(BuildContext context) {
    widget.sleep.createReminder(
        const Duration(minutes: 30), "Ghello my friend! Feeling sleepy?",
        notiBody:
            "You are more fun than anyone or anything I know, including bubble wrap.");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ...widget.sleep.reminders.map((reminder) => Padding(
            padding: const EdgeInsets.all(4),
            child: Reminder(sleep: widget.sleep, reminder: reminder))),
        IconButton(
            onPressed: () => _onAddPressed(context),
            icon: const Icon(Icons.add)),
      ],
    ));
  }
}
