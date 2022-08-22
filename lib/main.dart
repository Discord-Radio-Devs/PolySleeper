import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:polysleeper/common/sharedpreferenceshelper.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:polysleeper/models/user.dart';
import 'package:polysleeper/screens/home.dart';
import 'package:polysleeper/themes/default_theme.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'widgets/screencontainer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  await SharedPreferencesHelper.clearAll();
  await initializeNotifications();

  final Map<String, ScheduleModel> sexyAsses =
      await SharedPreferencesHelper.loadAllSchedules();
  print(sexyAsses.map((key, value) => MapEntry(key, value.toJson())));

  // FlutterError.onError = (details) {
  //   FlutterError.presentError(details);
  // };

  runApp(MyApp(loadedSchedules: sexyAsses));
}

class MyApp extends StatelessWidget {
  final Map<String, ScheduleModel> loadedSchedules;

  const MyApp({
    Key? key,
    required this.loadedSchedules,
  }) : super(key: key);

  // This widget is the square root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: UserModel.schedules(loadedSchedules)),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: getDefaultTheme(context),
          home: const ScreenContainer(
            child: MyHomePage(
              title: 'Poly Sleeper',
            ),
          )),
    );
  }
}
