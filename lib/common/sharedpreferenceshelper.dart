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
}
