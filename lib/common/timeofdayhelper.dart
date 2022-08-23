import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;

TZDateTime tzTimeOfToday(TimeOfDay timeOfDay) {
  return TZDateTime.from(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          timeOfDay.hour, timeOfDay.minute, DateTime.now().second),
      tz.local);
}

DateTime timeOfToday(TimeOfDay timeOfDay) {
  return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
      timeOfDay.hour, timeOfDay.minute, DateTime.now().second);
}

String dayTimeFormat(TimeOfDay dateTime) {
  return "${dateTime.hour < 10 ? "0${dateTime.hour}" : dateTime.hour}:${dateTime.minute < 10 ? "0${dateTime.minute}" : dateTime.minute}";
}

String durationHourMinFormat(int durationInMins) {
  return "${((durationInMins ~/ 60) > 0) ? "${durationInMins ~/ 60} h" : ""} ${(durationInMins % 60 > 0) ? "${durationInMins % 60} min" : ""}";
}
