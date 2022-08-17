import 'package:polysleeper/models/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<int?> getInt(String channelName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(channelName);
  }

  static Future<bool> incrementInt(String channelName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(channelName, (await getInt(channelName) ?? 0) + 1);
  }

  static Future<int> getAndIncrementInt(String channelName) async {
    int? returnVal = await getInt(channelName);
    if (returnVal != null) {
      incrementInt(channelName);
    }
    return returnVal ?? 0;
  }

  static Future<String?> getString(String channelName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(channelName);
  }

  static saveSchedule(ScheduleModel schedule) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("schedule-${schedule.name}", schedule.toJson());
  }

  static loadAllSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final List<ScheduleModel> schedules = [];

    for (final String key in prefs.getKeys()) {
      if (key.startsWith("schedule-")) {
        final String? storedContent = prefs.getString(key);
        if (storedContent != null) {
          schedules.add(ScheduleModel.fromJson(storedContent));
        }
      }
    }

    return schedules;
  }

  static clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
