import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/standalone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late final SharedPreferences prefs;

enum NotificationChannel { instant, scheduled }

initializeNotifications() async {
  // Used for persisent notification ids
  prefs = await SharedPreferences.getInstance();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Init local storage for notif ids
  for (NotificationChannel channel in NotificationChannel.values) {
    if (prefs.getInt(channel.name) == null) {
      prefs.setInt(channel.name, 0);
    }
  }

  if (prefs.getInt('notifications') == null) {
    prefs.setInt('notifications', 0);
  }
}

NotificationDetails _setUpNotificationDetails(
    NotificationChannel notificationChannel) {
  int channelIdCount = prefs.getInt(notificationChannel.name)!;
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('${notificationChannel.name}${channelIdCount}',
          notificationChannel.name,
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  prefs.setInt(notificationChannel.name, channelIdCount++);

  return platformChannelSpecifics;
}

showNotification(
  NotificationChannel notificationChannel,
  String? title,
  String? body, {
  String? payload,
}) async {
  await flutterLocalNotificationsPlugin.show(
      prefs.getInt('notifications') as int,
      title,
      body,
      _setUpNotificationDetails(notificationChannel),
      payload: payload);
}

scheduleNotification(
  NotificationChannel notificationChannel,
  String? title,
  String? body,
  TZDateTime dateTime, {
  String? payload,
}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      prefs.getInt('notifications') as int,
      title,
      body,
      dateTime,
      _setUpNotificationDetails(notificationChannel),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}
