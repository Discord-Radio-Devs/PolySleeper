import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/schedule.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ScheduleModel schedule, child) {
        return Text(schedule.toJson());
      },
    );
  }
}
