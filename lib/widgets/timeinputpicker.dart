import 'package:flutter/material.dart';

class TimeInputPicker extends StatefulWidget {
  const TimeInputPicker({Key? key}) : super(key: key);

  @override
  _TimeInputPickerState createState() => _TimeInputPickerState();
}

class _TimeInputPickerState extends State<TimeInputPicker> {
  List<bool> isSelected = [false, false, false];
  List<int> hasSelected = [];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(4.0),
      constraints: BoxConstraints(minHeight: 36.0),
      isSelected: isSelected,
      onPressed: (index) {
        // Respond to button selection
        setState(() {
          isSelected[index] = !isSelected[index];
          hasSelected.contains(index)
              ? hasSelected.remove(index)
              : hasSelected.add(index);
          if (hasSelected.length == 2) {
            Navigator.pop(context, {
              'StartTime': isSelected[0],
              'Duration': isSelected[1],
              'EndTime': isSelected[2]
            });
          }
        });

        // setState(() {
        //   isSelected[index] = !isSelected[index];
        //   hasSelected.contains(index)
        //       ? hasSelected.remove(index)
        //       : hasSelected.add(index);
        //   if (hasSelected.length >= 3) {
        //     isSelected[hasSelected[0]] = false;
        //     hasSelected.removeAt(0);
        //   }
        // });
      },
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('Start Time'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('Duration'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('End time'),
        ),
      ],
    );
  }
}
