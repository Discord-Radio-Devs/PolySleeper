import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/timeofdayhelper.dart';
import '../models/schedule.dart';
import '../models/sleep.dart';

class Sleep extends StatefulWidget {
  final ScheduleModel schedule;
  const Sleep({Key? key, required this.schedule}) : super(key: key);

  @override
  State<Sleep> createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  late FocusNode _focusNode;
  bool _focused = false;
  late FocusAttachment _focusAttachment;
  String newName = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'Button');
    _focusNode.addListener(_handleFocusChange);
    _focusAttachment = _focusNode.attach(context);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() {
        _focused = _focusNode.hasFocus;
      });
    }
  }

  _onDeletePressed(BuildContext context, SleepModel sleep) {
    widget.schedule.remove(sleep);
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

  Text _renderSubtitle(BuildContext context, SleepModel sleep) {
    if (_focused) {
      return Text(
          "${dayTimeFormat(sleep.startTime)} - ${dayTimeFormat(sleep.endTime)} \nfor ${durationHourMinFormat(sleep.durationInMins)}");
    }
    return Text(
        "${dayTimeFormat(sleep.startTime)} for ${durationHourMinFormat(sleep.durationInMins)}");
  }

  @override
  Widget build(BuildContext context) {
    _focusAttachment.reparent();
    return Consumer<SleepModel>(builder: (context, SleepModel sleep, _) {
      return Card(
          child: Column(children: [
        ListTile(
            onTap: () {
              if (_focused) {
                _focusNode.unfocus();
              } else {
                _focusNode.requestFocus();
              }
            },
            leading: Icon(
              Icons.hotel,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(sleep.name),
            subtitle: _renderSubtitle(context, sleep),
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
      ]));
    });
  }
}
