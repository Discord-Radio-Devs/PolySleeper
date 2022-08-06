import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late final SharedPreferences prefs;

class ScheduleModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Sleep> _sleeps;
  final String name;
  final List<DateTime> weekdays;

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
}

class Sleep {
  final int id;
  final String name;
  final TZDateTime dateTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Sleep(this.id, this.name, this.startTime, this.endTime)
      : dateTime = TZDateTime.from(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, startTime.hour, startTime.minute),
            tz.local) {
    scheduleNotification(
        NotificationChannel.scheduled, name, 'Time for $name 😴', dateTime);
  }

  factory Sleep.fromJson(Map<String, dynamic> jsonData) {
    return Sleep(
        jsonData['id'],
        jsonData['name'],
        TimeOfDay.fromDateTime(DateTime.parse(jsonData['startTime'])),
        TimeOfDay.fromDateTime(DateTime.parse(jsonData['endTime'])));
  }
}
