import 'dart:io';

import 'package:flutter/material.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:provider/provider.dart';

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
  _onRenamePressed(BuildContext context) async {
    String? titleResult =
        await _showTextDialog(context, widget.reminder.title, "Reminder title");
    if (titleResult == null) return;

    if (!mounted) return;
    String? bodyResult =
        await _showTextDialog(context, widget.reminder.body, "Reminder body");
    if (bodyResult == null) return;

    widget.reminder.rename(titleResult, bodyResult);
  }

  Future<String?> _showTextDialog(
      BuildContext context, String initValue, String title) async {
    String returnString = initValue;
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    child: Text("Cancel".toUpperCase()),
                    onPressed: () => Navigator.pop(context)),
                TextButton(
                    child: Text("Confirm".toUpperCase()),
                    onPressed: () => Navigator.pop(context, returnString))
              ],
              title: Text(title),
              content: TextFormField(
                initialValue: returnString,
                onChanged: (v) => returnString = v,
                onEditingComplete: () => Navigator.pop(context, returnString),
                textAlign: TextAlign.center,
              ),
            ).build(context));
  }

  _onDeletePressed(BuildContext context) {
    widget.sleep.removeSleepReminder(widget.reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Consumer<ReminderModel>(
        builder: (context, value, child) {
          return ListTile(
              leading: Icon(
                Icons.notifications,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(widget.reminder.title),
              subtitle: Text(widget.reminder.body),
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
              ));
        },
      )
    ]));
  }
}
