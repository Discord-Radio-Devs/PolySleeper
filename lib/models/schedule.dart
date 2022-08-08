import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

import 'package:timezone/timezone.dart' as tz;

late final SharedPreferences prefs;

class ScheduleModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Sleep> _sleeps;
  final String name;
  final List<int> weekdays;

  ScheduleModel(this.name, this.weekdays, this._sleeps);

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Sleep> get sleeps {
    return UnmodifiableListView(_sleeps);
  }

  /// Adds [sleep] to the schedule.
  void add(Sleep sleep) {
    _sleeps.add(sleep);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes [sleep] from schedule.
  void remove(Sleep sleep) {
    _sleeps.remove(sleep);

    notifyListeners();
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> jsonData) {
    return ScheduleModel(jsonData['name'], jsonData['weekdays'].split(';'),
        jsonData['sleeps'].split(';'));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weekdays': weekdays.join(';'),
      'sleeps': sleeps.map((e) => e.toJson()).join(';')
    };
  }
}

class Sleep {
  final String name;
  final TZDateTime dateTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Sleep(this.name, this.startTime, this.endTime)
      : dateTime = TZDateTime.from(
            DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                startTime.hour,
                startTime.minute,
                DateTime.now().second),
            tz.local) {
    periodicallyShowNotification(
        NotificationChannel.instant, name, 'Time for $name 😴 NOW!', dateTime);
  }

  factory Sleep.fromJson(Map<String, dynamic> jsonData) {
    return Sleep(
        jsonData['name'],
        TimeOfDay.fromDateTime(DateTime.parse(jsonData['startTime'])),
        TimeOfDay.fromDateTime(DateTime.parse(jsonData['endTime'])));
  }

  Map<String, dynamic> toJson() {
    DateTime now = DateTime.now();
    return {
      name: name,
      'startTime': DateTime(
              now.year, now.month, now.day, startTime.hour, startTime.minute)
          .toString(),
      'endTime':
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute)
              .toString()
    };
  }
}
