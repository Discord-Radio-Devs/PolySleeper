import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polysleeper/common/sharedpreferenceshelper.dart';
import 'package:polysleeper/models/sleep.dart';

class ScheduleModel extends ChangeNotifier {
  /// Internal, private state of the schedule.
  final Map<String, SleepModel> _sleeps;
  final String name;
  final List<int> weekdays;

  ScheduleModel(this.name, this.weekdays) : _sleeps = <String, SleepModel>{};

  ScheduleModel.sleeps(this.name, this.weekdays, this._sleeps);

  ScheduleModel.sleepsFromJson(
      this.name, this.weekdays, List<String> jsonSleeps)
      : _sleeps = Map.fromIterable(
          jsonSleeps.map((String element) => SleepModel.fromJson(element)),
          key: (sleep) => sleep.name,
        );

  /// An unmodifiable view of the items in the sleeping schedule.
  UnmodifiableMapView<String, SleepModel> get sleeps {
    return UnmodifiableMapView(_sleeps);
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
    var sleepsList = sleeps.entries.map((e) => e.value).toList();
    return json.encode(
        {'name': name, 'weekdays': weekdays.join(';'), 'sleeps': sleepsList});
  }

  /// Adds [sleep] to the schedule.
  void add(SleepModel sleep) {
    if (_sleeps.containsKey(sleep.name)) {
      throw Exception(
          "A sleep with name ${sleep.name} has already been declared!");
    }
    _sleeps[sleep.name] = sleep;
    sleep.createNotification();
    _save();
  }

  /// Removes [sleep] from schedule.
  void remove(SleepModel sleep) {
    _sleeps.remove(sleep);
    sleep.removeSleepNotification();
    _save();
  }

  void _save() {
    SharedPreferencesHelper.saveSchedule(this);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
