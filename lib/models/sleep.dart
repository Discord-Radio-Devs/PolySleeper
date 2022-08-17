import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:timezone/timezone.dart';

import 'package:timezone/timezone.dart' as tz;

class SleepModel {
  final String name;
  final TZDateTime dateTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  int notiId = -1;

  SleepModel(this.name, this.startTime, this.endTime)
      : dateTime = TZDateTime.from(
            DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                startTime.hour,
                startTime.minute,
                DateTime.now().second),
            tz.local);

  /// For creation of a [SleepModel] when you already have a notification ID [notiId]
  SleepModel.notiId(this.name, this.startTime, this.endTime, this.notiId)
      : dateTime = TZDateTime.from(
            DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                startTime.hour,
                startTime.minute,
                DateTime.now().second),
            tz.local);

  factory SleepModel.fromJson(String jsonData) {
    var decodedData = json.decode(jsonData);
    return SleepModel.notiId(
        decodedData['name'],
        TimeOfDay.fromDateTime(DateTime.parse(decodedData['startTime'])),
        TimeOfDay.fromDateTime(DateTime.parse(decodedData['endTime'])),
        decodedData['notiId']);
  }

  String toJson() {
    DateTime now = DateTime.now();
    return json.encode({
      'name': name,
      'notiId': notiId,
      'startTime': DateTime(
              now.year, now.month, now.day, startTime.hour, startTime.minute)
          .toString(),
      'endTime':
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute)
              .toString()
    });
  }

  createNotification([String? message]) async {
    notiId = await periodicallyShowNotification(NotificationChannel.instant,
        name, message ?? 'Time for $name 😴 NOW! He said NOW!', dateTime);
  }

  removeSleepNotification() {
    removeNotification(notiId);
  }
}
