import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:polysleeper/common/timeofdayhelper.dart';
import 'package:polysleeper/models/reminder.dart';
import 'package:timezone/timezone.dart';

class SleepModel extends ChangeNotifier {
  String _name;
  final TZDateTime dateTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  List<ReminderModel> _reminders = [];
  ReminderModel? ongoing;

  SleepModel(this._name, this.startTime, this.endTime)
      : dateTime = tzTimeOfToday(startTime);

  SleepModel.calcEndTime(this._name, this.startTime, sleepDuration)
      : dateTime = tzTimeOfToday(startTime),
        endTime =
            TimeOfDay.fromDateTime(tzTimeOfToday(startTime).add(sleepDuration));

  SleepModel.calcStartTime(this._name, this.endTime, sleepDuration)
      : dateTime = tzTimeOfToday(endTime),
        startTime = TimeOfDay.fromDateTime(
            tzTimeOfToday(endTime).subtract(sleepDuration));

  /// For creation of a [SleepModel] when you already have a notification ID [reminders]
  SleepModel.reminders(
      this._name, this.startTime, this.endTime, this.ongoing, this._reminders)
      : dateTime = tzTimeOfToday(startTime);

  SleepModel.remindersFromJson(this._name, this.startTime, this.endTime,
      this.ongoing, List<String> jsonReminders)
      : _reminders = List.from(jsonReminders
            .map((String element) => ReminderModel.fromJson(element))),
        dateTime = tzTimeOfToday(startTime);

  factory SleepModel.fromJson(String jsonData) {
    var decodedData = json.decode(jsonData);
    return SleepModel.remindersFromJson(
        decodedData['_name'],
        TimeOfDay.fromDateTime(DateTime.parse(decodedData['startTime'])),
        TimeOfDay.fromDateTime(DateTime.parse(decodedData['endTime'])),
        ReminderModel.fromJson(decodedData['ongoing']),
        List.castFrom(decodedData['reminders']));
  }

  UnmodifiableListView<ReminderModel> get reminders {
    return UnmodifiableListView(_reminders);
  }

  int get durationInMins {
    var minsInDay = 24 * 60;
    var endTimeMins = endTime.hour * 60 + endTime.minute;
    var startTimeMins = startTime.hour * 60 + startTime.minute;
    return (endTimeMins + minsInDay - startTimeMins) % minsInDay;
  }

  double get durationInHours {
    int minsInDay = 24 * 60;
    int endTimeMins = endTime.hour * 60 + endTime.minute;
    int startTimeMins = startTime.hour * 60 + startTime.minute;
    return (endTimeMins + minsInDay - startTimeMins) % 24;
  }

  String get name {
    return _name;
  }

  String toJson() {
    return json.encode({
      '_name': _name,
      'ongoing': ongoing,
      'reminders': _reminders,
      'startTime': timeOfToday(startTime).toString(),
      'endTime': timeOfToday(endTime).toString()
    });
  }

  createReminder(
    Duration duration,
    String title, {
    String? notiBody,
  }) async {
    ReminderModel reminder = ReminderModel(
        tzTimeOfToday(startTime).subtract(duration), title,
        notiBody: notiBody);

    reminder.notiId = await periodicallyShowNotification(
        NotificationChannel.instant,
        reminder.title,
        reminder.body,
        reminder.reminderTime);
    _reminders.add(reminder);
    _save();
  }

  addOngoing(ReminderModel ongoing) async {
    ongoing.notiId = await periodicallyShowNotification(
        NotificationChannel.instant,
        ongoing.title,
        ongoing.body,
        ongoing.reminderTime,
        ongoing: true,
        timeoutAfter: durationInMins * 60 * 1000);
    this.ongoing = ongoing;
    _save();
  }

  rename(String newName) {
    _name = newName;
    _save();
  }

  removeOngoing() {
    if (ongoing != null) {
      removeReminders([ongoing!]);
      ongoing = null;
      _save();
    }
  }

  removeSleepReminders() {
    removeReminders(_reminders);
    _reminders.clear();
    _save();
  }

  void _save() {
    notifyListeners();
  }
}
