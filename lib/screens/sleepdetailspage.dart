import 'package:flutter/material.dart';
import 'package:polysleeper/models/reminder.dart';
import 'package:polysleeper/models/sleep.dart';
import 'package:polysleeper/widgets/reminder.dart';
import 'package:provider/provider.dart';

class SleepDetailsPage extends StatefulWidget {
  final SleepModel sleep;
  const SleepDetailsPage({Key? key, required this.sleep}) : super(key: key);

  @override
  State<SleepDetailsPage> createState() => _SleepDetailsPageState();
}

class _SleepDetailsPageState extends State<SleepDetailsPage> {
  _onAddPressed(BuildContext context, SleepModel sleep) async {
    String? titleResult =
        await _showTextDialog(context, "Feeling tired?", "Reminder title");
    if (titleResult == null) return;

    if (!mounted) return;
    String? bodyResult = await _showTextDialog(
        context, "It is soon time to sleep!", "Reminder body");
    if (bodyResult == null) return;

    if (!mounted) return;
    Duration? durationResult = await _createDuration(context);
    if (durationResult == null) return;

    sleep.createReminder(durationResult, titleResult, notiBody: bodyResult);
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

  Future<Duration?> _createDuration(BuildContext context) async {
    TimeOfDay? durationTimeOfDay = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'When do you want to be reminded?'.toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    Duration? durationResult = durationTimeOfDay != null
        ? Duration(
            hours: durationTimeOfDay.hour, minutes: durationTimeOfDay.minute)
        : null;
    return durationResult;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SleepModel>.value(
        value: widget.sleep,
        child: Center(child: Consumer<SleepModel>(
          builder: (context, sleep, child) {
            return Column(
              children: [
                ...sleep.reminders.map((reminder) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: ChangeNotifierProvider<ReminderModel>.value(
                        value: reminder,
                        child: Reminder(sleep: sleep, reminder: reminder)))),
                IconButton(
                    onPressed: () => _onAddPressed(context, sleep),
                    icon: const Icon(Icons.add)),
              ],
            );
          },
        )));
  }
}
