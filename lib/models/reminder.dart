import 'dart:convert';

import 'package:timezone/timezone.dart';

import 'package:timezone/timezone.dart' as tz;

class Reminder {
  int notiId = -1;
  final TZDateTime reminderTime;
  final String title;
  final String body;

  Reminder(this.reminderTime, this.title, {String? notiBody})
      : body = notiBody ?? "Reminder to go to sleep soon! 🏃‍♂️";
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
    return json.encode({
      'name': title,
      'body': body,
      'reminderTime': DateTime.parse(reminderTime.toIso8601String()).toString(),
      'notiId': notiId
    });
  }
}
