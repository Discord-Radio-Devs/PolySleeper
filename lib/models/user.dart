import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:polysleeper/models/schedule.dart';

class UserModel extends ChangeNotifier {
  final Map<String, ScheduleModel> _schedules;

  UserModel() : _schedules = <String, ScheduleModel>{};
  UserModel.schedules(this._schedules);

  /// An unmodifiable view of the items in the sleeping schedule.
  UnmodifiableMapView<String, ScheduleModel> get schedules {
    return UnmodifiableMapView(_schedules);
  }

  /// Adds [schedule] to the user.
  void addSchedule(ScheduleModel schedule) {
    if (_schedules.containsKey(schedule.name)) {
      throw Exception(
          "A schedule with name ${schedule.name} has already been declared!");
    }
    _schedules[schedule.name] = schedule;
    _save();
  }

  /// Removes [schedule] from user.
  void removeSchedule(ScheduleModel schedule) {
    _schedules.remove(schedule);
    _save();
  }

  void _save() {
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
