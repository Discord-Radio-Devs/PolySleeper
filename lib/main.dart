import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polysleeper/common/notifications.dart';
import 'package:polysleeper/common/sharedpreferenceshelper.dart';
import 'package:polysleeper/models/schedule.dart';
import 'package:polysleeper/models/user.dart';
import 'package:polysleeper/screens/home.dart';
import 'package:provider/provider.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  await initializeNotifications();

  // await SharedPreferencesHelper.clearAll();

  final List<ScheduleModel> sexyAsses =
      await SharedPreferencesHelper.loadAllSchedules();
  print(sexyAsses.map((e) => e.toJson()));

  runApp(MyApp(loadedSchedules: sexyAsses));
}

class MyApp extends StatelessWidget {
  final List<ScheduleModel> loadedSchedules;

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
            value: UserModel.schedules(loadedSchedules))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xff201f47),
          colorScheme: ColorScheme(
              primary: Colors.green[300]!,
              primaryContainer: Colors.green[600]!,
              secondary: Colors.indigo[600]!,
              secondaryContainer: Colors.deepPurple[800]!,
              surface: const Color(0xff201f47),
              background: const Color(0xff201f47),
              error: Colors.red[400]!,
              onPrimary: Colors.blueGrey[700]!,
              onSecondary: const Color(0xFF323367),
              onSurface: Colors.indigo[400]!,
              onBackground: Colors.indigo[400]!,
              onError: Colors.red[50]!,
              brightness: Brightness.dark),
          textTheme: Theme.of(context)
              .textTheme
              .apply(
                fontFamily: GoogleFonts.nunito().fontFamily,
                displayColor: Colors.indigo[300],
                bodyColor: Colors.indigo,
              )
              .merge(TextTheme(
                  headline1: const TextStyle(fontSize: 32, letterSpacing: 0.5),
                  headline2: const TextStyle(fontSize: 28),
                  headline3: GoogleFonts.montserrat(
                    fontSize: 24,
                    color: Colors.green[300],
                  ),
                  headline4: GoogleFonts.montserrat(
                    fontSize: 21,
                    color: Colors.deepPurple[400],
                    fontWeight: FontWeight.w300,
                  ))),
          iconTheme: IconThemeData(
            color: Colors.blueGrey[700],
          ),
          timePickerTheme: TimePickerThemeData(
              helpTextStyle: TextStyle(color: Colors.indigo[300])),
        ),
        home: const MyHomePage(
          title: 'Poly Sleeper',
        ),
      ),
    );
  }
}
