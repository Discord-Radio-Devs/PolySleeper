import 'package:flutter/material.dart';
import 'package:polysleeper/models/sleep.dart';

import '../models/reminder.dart';

class Reminder extends StatefulWidget {
  final SleepModel sleep;
  final ReminderModel reminder;
  const Reminder({Key? key, required this.sleep, required this.reminder})
      : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  _onRenamePressed(BuildContext context) {}

  _onDeletePressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      ListTile(
          leading: Icon(
            Icons.notifications,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(widget.reminder.title),
          subtitle: Text(widget.reminder.title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => _onRenamePressed(context),
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () => _onDeletePressed(context),
                  icon: const Icon(Icons.delete)),
            ],
          ))
    ]));
  }
}
