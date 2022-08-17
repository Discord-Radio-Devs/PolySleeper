import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:polysleeper/models/schedule.dart';

class UserModel extends ChangeNotifier {
  final List<ScheduleModel> _schedules;

  UserModel() : _schedules = [];
  UserModel.schedules(this._schedules);

  /// An unmodifiable view of the items in the sleeping schedule.
  UnmodifiableListView<ScheduleModel> get schedules {
    return UnmodifiableListView(_schedules);
  }

  /// Adds [schedule] to the user.
  void add(ScheduleModel schedule) {
    schedule.save();
    _schedules.add(schedule);
    save();
  }

  /// Removes [schedule] from user.
  void remove(ScheduleModel schedule) {
    _schedules.remove(schedule);
    save();
  }

  void save() {
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
