import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/timeofdayhelper.dart';
import '../models/schedule.dart';
import '../models/sleep.dart';

class Sleep extends StatelessWidget {
  final ScheduleModel schedule;
  Sleep({Key? key, required this.schedule}) : super(key: key);

  late String newName;

  _onDeletePressed(BuildContext context, SleepModel sleep) {
    schedule.remove(sleep);
  }

  _onRenamePressed(BuildContext context, SleepModel sleep) async {
    newName = sleep.name;

    String? renameResult = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    child: Text("Cancel".toUpperCase()),
                    onPressed: () => Navigator.pop(context)),
                TextButton(
                    child: Text("Confirm".toUpperCase()),
                    onPressed: () => Navigator.pop(context, newName))
              ],
              title: const Text("Sleep Name"),
              content: TextFormField(
                initialValue: sleep.name,
                onChanged: (v) => newName = v,
                onEditingComplete: () => Navigator.pop(context, newName),
                textAlign: TextAlign.center,
              ),
            ).build(context));

    if (renameResult != null) {
      sleep.rename(renameResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SleepModel>(builder: (context, SleepModel sleep, _) {
      return Center(
          child: Card(
        child: Column(children: [
          ListTile(
              leading: const Icon(Icons.hotel),
              title: Text(sleep.name),
              subtitle: Text(
                  "${dayTimeFormat(sleep.startTime)} for ${durationHourMinFormat(sleep.durationInMins)}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => _onRenamePressed(context, sleep),
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () => _onDeletePressed(context, sleep),
                      icon: const Icon(Icons.delete)),
                ],
              ))
        ]),
      ));
    });
  }
}
