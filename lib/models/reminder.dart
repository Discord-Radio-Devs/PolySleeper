import 'dart:convert';

import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderModel {
  int notiId = -1;
  final TZDateTime reminderTime;
  final String title;
  final String body;

  ReminderModel(this.reminderTime, this.title, {String? notiBody})
      : body = notiBody ?? "Reminder to go to sleep soon! 🏃‍♂️";
  ReminderModel.notiId(this.body, this.reminderTime, this.title, this.notiId);

  factory ReminderModel.fromJson(String jsonData) {
    var decodedData = json.decode(jsonData);
    return ReminderModel.notiId(
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
