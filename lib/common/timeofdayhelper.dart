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
