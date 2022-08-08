import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

import 'package:timezone/timezone.dart' as tz;

late final SharedPreferences prefs;

class ScheduleModel extends ChangeNotifier {
  /// Internal, private state of the schedule.
  final List<Sleep> _sleeps;
  final String name;
  final List<int> weekdays;

  ScheduleModel(this.name, this.weekdays) : _sleeps = [];

  ScheduleModel.sleeps(this.name, this.weekdays, this._sleeps);

  ScheduleModel.sleepsFromJson(
      this.name, this.weekdays, List<String> jsonSleeps)
      : _sleeps = List.from(
            jsonSleeps.map((String element) => Sleep.fromJson(element)));

  /// An unmodifiable view of the items in the sleeping schedule.
  UnmodifiableListView<Sleep> get sleeps {
    return UnmodifiableListView(_sleeps);
  }

  factory ScheduleModel.fromJson(String jsonData) {
    var decodedData = json.decode(jsonData);

    // .map makes it MappedListIterable<String, dynamic> .toList() makes it List<dynamic> so we have to use
    // List.castFrom as MappedListIterable<String, dynamic>.toList<int>() does not exist and is the only
    // method that can autocast it to List<int>
    return ScheduleModel.sleepsFromJson(
        decodedData['name'],
        List.castFrom(decodedData['weekdays']
            .split(';')
            .map((e) => int.parse(e))
            .toList()),
        List.castFrom(decodedData['sleeps']));
  }

  String toJson() {
    return json.encode(
        {'name': name, 'weekdays': weekdays.join(';'), 'sleeps': sleeps});
  }

  /// Adds [sleep] to the schedule.
  void add(Sleep sleep) {
    _sleeps.add(sleep);
    sleep.createNotification();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes [sleep] from schedule.
  void remove(Sleep sleep) {
    _sleeps.remove(sleep);
    sleep.removeSleepNotification();

    notifyListeners();
  }
}

class Sleep {
  final String name;
  final TZDateTime dateTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  int notiId = -1;

  Sleep(this.name, this.startTime, this.endTime)
      : dateTime = TZDateTime.from(
            DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                startTime.hour,
                startTime.minute,
                DateTime.now().second),
            tz.local);

  /// For creation of a [Sleep] when you already have a notification ID [notiId]
  Sleep.notiId(this.name, this.startTime, this.endTime, this.notiId)
      : dateTime = TZDateTime.from(
            DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                startTime.hour,
                startTime.minute,
                DateTime.now().second),
            tz.local);

  factory Sleep.fromJson(String jsonData) {
    var decodedData = json.decode(jsonData);
    return Sleep.notiId(
        decodedData['name'],
        TimeOfDay.fromDateTime(DateTime.parse(decodedData['startTime'])),
        TimeOfDay.fromDateTime(DateTime.parse(decodedData['endTime'])),
        decodedData['notiId']);
  }

  String toJson() {
    DateTime now = DateTime.now();
    return json.encode({
      'name': name,
      'notiId': notiId,
      'startTime': DateTime(
              now.year, now.month, now.day, startTime.hour, startTime.minute)
          .toString(),
      'endTime':
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute)
              .toString()
    });
  }

  createNotification([String? message]) async {
    notiId = await periodicallyShowNotification(NotificationChannel.instant,
        name, message ?? 'Time for $name 😴 NOW! He said NOW!', dateTime);
  }

  removeSleepNotification() {
    removeNotification(notiId);
  }
}
