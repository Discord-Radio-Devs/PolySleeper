import 'dart:convert';

import 'package:timezone/timezone.dart';

import 'package:timezone/timezone.dart' as tz;

class Reminder {
  int notiId = -1;
  final TZDateTime reminderTime;
  final String title;
  final String body;

  Reminder(this.reminderTime, this.title, {String? notiBody})
      : body = notiBody ?? "Time for $title 😴 NOW! He said NOW!";
  Reminder.notiId(this.body, this.reminderTime, this.title, this.notiId);

  factory Reminder.fromJson(String jsonData) {
    var decodedData = json.decode(jsonData);
    return Reminder.notiId(
        decodedData['body'],
        TZDateTime.from(DateTime.parse(decodedData['reminderTime']), tz.local),
        decodedData['name'],
        decodedData['notiId']);
  }

  String toJson() {
    DateTime now = DateTime.now();
    return json.encode({
      'name': title,
      'body': body,
      'reminderTime': DateTime(now.year, now.month, now.day, reminderTime.hour,
              reminderTime.minute)
          .toString(),
      'notiId': notiId
    });
  }
}
