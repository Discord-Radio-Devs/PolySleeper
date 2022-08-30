import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderModel extends ChangeNotifier {
  int notiId = -1;
  final TZDateTime reminderTime;
  String _title;
  String _body;

  String get title {
    return _title;
  }

  String get body {
    return _body;
  }

  ReminderModel(this.reminderTime, this._title, {String? notiBody})
      : _body = notiBody ?? "Reminder to go to sleep soon! 🏃‍♂️";
  ReminderModel.notiId(this._body, this.reminderTime, this._title, this.notiId);

  rename(String newTitle, String newBody) async {
    removeReminder(this);

    notiId = await periodicallyShowNotification(
        NotificationChannel.instant, newTitle, newBody, reminderTime);
    _title = newTitle;
    _body = newBody;

    notifyListeners();
  }

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
