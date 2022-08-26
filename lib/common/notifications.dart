import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:polysleeper/common/sharedpreferenceshelper.dart';
import 'package:polysleeper/models/reminder.dart';
import 'package:timezone/standalone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

enum NotificationChannel { instant, scheduled }

initializeNotifications() async {
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
    SharedPreferencesHelper.incrementInt(channel.name);
  }

  SharedPreferencesHelper.incrementInt('notifications');
}

Future<NotificationDetails> _setUpNotificationDetails(
    NotificationChannel notificationChannel,
    {bool? ongoing,
    int? timeoutAfter}) async {
  int? channelIdCount =
      await SharedPreferencesHelper.getInt(notificationChannel.name) ?? 0;

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '${notificationChannel.name}$channelIdCount',
    notificationChannel.name,
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: ongoing ?? false,
    timeoutAfter: timeoutAfter,
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  SharedPreferencesHelper.incrementInt(notificationChannel.name);
  SharedPreferencesHelper.incrementInt('notifications');

  return platformChannelSpecifics;
}

showNotification(
  NotificationChannel notificationChannel,
  String? title,
  String? body, {
  String? payload,
}) async {
  await flutterLocalNotificationsPlugin.show(
      (await SharedPreferencesHelper.getInt('notifications'))!,
      title,
      body,
      await _setUpNotificationDetails(notificationChannel),
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
      (await SharedPreferencesHelper.getInt('notifications'))!,
      title,
      body,
      dateTime,
      await _setUpNotificationDetails(notificationChannel),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

Future<int> periodicallyShowNotification(
    NotificationChannel notificationChannel,
    String? title,
    String? body,
    TZDateTime dateTime,
    {String? payload,
    bool? ongoing,
    int? timeoutAfter}) async {
  int notiId = ((await SharedPreferencesHelper.getInt('notifications'))!);
  flutterLocalNotificationsPlugin.zonedSchedule(
      notiId,
      title,
      body,
      dateTime.add(const Duration(seconds: 1)),
      matchDateTimeComponents: DateTimeComponents.time,
      await _setUpNotificationDetails(notificationChannel,
          ongoing: ongoing, timeoutAfter: timeoutAfter),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);

  return notiId;
}

removeReminders(List<ReminderModel> reminders) {
  try {
    for (ReminderModel r in reminders) {
      flutterLocalNotificationsPlugin.cancel(r.notiId);
    }
  } catch (e) {
    debugPrint("Bitch whatcha tryin to delete 🤨");
  }
}

clearAllNotifications() {
  flutterLocalNotificationsPlugin.cancelAll();
}
