import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:polysleeper/common/sharedpreferenceshelper.dart';
import 'package:polysleeper/models/schedule.dart';

class UserModel extends ChangeNotifier {
  final Map<String, ScheduleModel> _schedules;

  //This makes detection of active schedules way easier
  static const String activeName = "%active";

  UserModel() : _schedules = <String, ScheduleModel>{};
  UserModel.schedules(this._schedules);

  ///modifiable view of the items in the sleeping schedule.
  UnmodifiableMapView<String, ScheduleModel> get schedules {
    return UnmodifiableMapView(_schedules);
  }

  /// Adds [schedule] to the user.
  void addSchedule(ScheduleModel schedule) {
    if (schedule.name == activeName) {
      throw Exception("Schedule name not allowed");
    }
    if (_schedules.containsKey(schedule.name)) {
      throw Exception(
          "A schedule with name ${schedule.name} has already been declared!");
    }
    schedule.active = true;
    _schedules[activeName] = schedule;
    _schedules[schedule.name] = schedule;

    _save();
  }

  void setActive(String scheduleName) {
    if (!_schedules.containsKey(scheduleName)) {
      throw Exception(
          "The schedule to set active is not registered for this user");
    }
    _schedules[activeName] = _schedules[scheduleName]!;

    _save();
  }

  /// Removes [schedule] from user.
  void removeSchedule(ScheduleModel schedule) {
    if (schedule.active) {
      _schedules.removeWhere((key, value) => key == UserModel.activeName);
      SharedPreferencesHelper.deleteSchedule(UserModel.activeName);
    }

    _schedules.removeWhere(((key, value) => key == schedule.name));

    SharedPreferencesHelper.deleteSchedule(schedule.name);

    _save();
  }

  void clearSchedules() async {
    clearAllNotifications();
    _schedules.forEach((key, value) {
      if (value.active) {
        SharedPreferencesHelper.deleteSchedule(UserModel.activeName);
      }

      SharedPreferencesHelper.deleteSchedule(value.name);
    });

    _schedules.clear();
    _save();
  }

  void _save() {
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
