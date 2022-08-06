// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleeper/common/notifications.dart';

import 'package:polysleeper/main.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  test('Check content of your moms vagina', () async {
    WidgetsFlutterBinding.ensureInitialized();

    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    await initializeNotifications();

    ScheduleModel scheduleModel = ScheduleModel('Late Siesta', [
      1,
      3,
      4,
      7
    ], [
      Sleep('Core Sleep', TimeOfDay.fromDateTime(DateTime.now()),
          TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))))
    ]);
  });
}
