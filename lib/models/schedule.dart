import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polysleeper/common/sharedpreferenceshelper.dart';
import 'package:polysleeper/models/reminder.dart';
import 'package:polysleeper/models/sleep.dart';

class ScheduleModel extends ChangeNotifier {
  /// Internal, private state of the schedule.
  final List<SleepModel> _sleeps;
  final String name;
  final List<int> weekdays;
  bool active = false;

  ScheduleModel(this.name, this.weekdays)
      : _sleeps = [],
        active = true;

  ScheduleModel.sleeps(this.name, this.weekdays, this._sleeps) {
    for (SleepModel sleep in _sleeps) {
      sleep.addListener(() => _save());
    }
  }

  ScheduleModel.sleepsFromJson(
      this.name, this.weekdays, this.active, List<String> jsonSleeps)
      : _sleeps = List.from(
            jsonSleeps.map((String element) => SleepModel.fromJson(element))) {
    for (SleepModel sleep in _sleeps) {
      sleep.addListener(() => _save());
    }
  }

  /// An unmodifiable view of the items in the sleeping schedule.
  UnmodifiableListView<SleepModel> get sleeps {
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
        decodedData['active'],
        List.castFrom(decodedData['sleeps']));
  }

  String toJson() {
    return json.encode({
      'name': name,
      'weekdays': weekdays.join(';'),
      'active': active,
      'sleeps': sleeps
    });
  }

  /// Adds [sleep] to the schedule.
  void add(SleepModel sleep) {
    _sleeps.add(sleep);
    sleep.addListener(() => _save());
    sleep.addOngoing(ReminderModel(sleep.dateTime, sleep.name,
        notiBody: "It's time for ${sleep.name}"));
    _save();
  }

  /// Removes [sleep] from schedule.
  void remove(SleepModel sleep) {
    _sleeps.remove(sleep);
    sleep.removeOngoing();
    sleep.removeSleepReminders();
    _save();
  }

  void clear() {
    for (SleepModel sleep in sleeps) {
      sleep.removeOngoing();
      sleep.removeSleepReminders();
    }
    _sleeps.clear();
    _save();
  }

  void _save() {
    SharedPreferencesHelper.saveSchedule(this);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
