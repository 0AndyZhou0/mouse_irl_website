import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mouse_irl_website/database.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';

class AddTime extends StatefulWidget {
  const AddTime({super.key});

  @override
  State<AddTime> createState() => _AddTimeState();
}

class _AddTimeState extends State<AddTime> {
  DateTime _dateTime = DateTime.now();
  // DateTime _date = DateTime.now();
  // DateTime _time = DateTime.now();

  void onDateTimeChanged(DateTime newDateTime) {
    setState(() {
      _dateTime = newDateTime;
    });
  }

  // void onDateChanged(DateTime newDate) {
  //   setState(() {
  //     _date = newDate;
  //   });
  // }

  // void onTimeChanged(DateTime newTime) {
  //   setState(() {
  //     _time = newTime;
  //   });
  // }

  //taken from https://pub.dev/packages/datetime_picker_formfield_new
  // Widget basicDateField() {
  //   final format = DateFormat("yyyy-MM-dd");
  //   return Column(children: <Widget>[
  //     Text('Basic date field (${format.pattern})'),
  //     DateTimeField(
  //       format: format,
  //       onShowPicker: (context, currentValue) {
  //         return showDatePicker(
  //           context: context,
  //           firstDate: DateTime(1900),
  //           initialDate: currentValue ?? DateTime.now(),
  //           lastDate: DateTime(2100),
  //         );
  //       },
  //       onChanged: (value) {
  //         if (value != null) {
  //           onDateChanged(value);
  //         }
  //       },
  //     ),
  //   ]);
  // }

  // Widget basicTimeField() {
  //   final format = DateFormat("HH:mm");
  //   return Column(children: <Widget>[
  //     Text('Basic time field (${format.pattern})'),
  //     DateTimeField(
  //       format: format,
  //       onShowPicker: (context, currentValue) async {
  //         final time = await showTimePicker(
  //           context: context,
  //           initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
  //         );
  //         return DateTimeField.convert(time);
  //       },
  //       onChanged: (value) {
  //         if (value != null) {
  //           onTimeChanged(value);
  //         }
  //       },
  //     ),
  //   ]);
  // }

  Widget basicDateTimeField() {
    final format = DateFormat("yyyy-MM-dd HH:mm");
    return Column(children: <Widget>[
      Text('Basic date & time field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          return await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          ).then((DateTime? date) async {
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          });
        },
        onChanged: (value) {
          if (value != null) {
            onDateTimeChanged(value);
          }
        },
      ),
    ]);
  }

  Widget addDateButton() {
    return ElevatedButton(
      onPressed: () {
        Database().addTime(_dateTime);
        Navigator.pop(context);
      },
      child: const Text('Add Date'),
    );
  }

  Widget addTimeForm() {
    return Column(
      children: [
        basicDateTimeField(),
        const SizedBox(
          height: 20,
        ),
        addDateButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: addTimeForm(),
      ),
    );
  }
}
