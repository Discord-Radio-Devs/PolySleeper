import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polysleeper/common/sharedpreferenceshelper.dart';
import 'package:polysleeper/models/sleep.dart';

class ScheduleModel {
  /// Internal, private state of the schedule.
  final List<SleepModel> _sleeps;
  final String name;
  final List<int> weekdays;

  ScheduleModel(this.name, this.weekdays) : _sleeps = [];

  ScheduleModel.sleeps(this.name, this.weekdays, this._sleeps);

  ScheduleModel.sleepsFromJson(
      this.name, this.weekdays, List<String> jsonSleeps)
      : _sleeps = List.from(
            jsonSleeps.map((String element) => SleepModel.fromJson(element)));

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
        List.castFrom(decodedData['sleeps']));
  }

  String toJson() {
    return json.encode(
        {'name': name, 'weekdays': weekdays.join(';'), 'sleeps': sleeps});
  }

  /// Adds [sleep] to the schedule.
  void add(SleepModel sleep) {
    _sleeps.add(sleep);
    sleep.createNotification();
    save();
  }

  /// Removes [sleep] from schedule.
  void remove(SleepModel sleep) {
    _sleeps.remove(sleep);
    sleep.removeSleepNotification();
    save();
  }

  void save() {
    SharedPreferencesHelper.saveSchedule(this);
    // This call tells the widgets that are listening to this model to rebuild.
    //notifyListeners();
  }
}
