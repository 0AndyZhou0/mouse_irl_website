import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mouse_irl_website/database.dart';

class AddTime extends StatefulWidget {
  const AddTime({super.key});

  @override
  State<AddTime> createState() => _AddTimeState();
}

final TextEditingController _timeBoxController = TextEditingController();
final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
final DateFormat timeFormat = DateFormat("HH:mm");
final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

DateTime? selectedDateTime;

class _AddTimeState extends State<AddTime> {
  Key _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    selectedDateTime = selectedDateTime ?? DateTime.now();
  }

  void updateCupertinoDatePicker() {
    setState(() {
      _key = UniqueKey();
    });
  }

  Widget basicDateTimeField() {
    return Column(
      children: <Widget>[
        Text('Date & Time field format (${format.pattern})'),
        TextField(
          controller: _timeBoxController,
          onChanged: (value) => setState(() {
            try {
              selectedDateTime = format.parse(value);
            } finally {
              _timeBoxController.text = format.format(selectedDateTime!);
            }
          }),
        )
      ],
    );
  }

  Widget editDateField() {
    return ListTile(
      title: Center(child: Text(dateFormat.format(selectedDateTime!))),
      onTap: () async {
        final date = await showDatePicker(
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            child: child!,
          ),
          context: context,
          initialDate: selectedDateTime!,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            selectedDateTime = selectedDateTime!.copyWith(
              year: date.year,
              month: date.month,
              day: date.day,
            );
            updateCupertinoDatePicker();
          });
        }
      },
    );
  }

  Widget editTimeField() {
    return ListTile(
      title: Center(child: Text(timeFormat.format(selectedDateTime!))),
      onTap: () async {
        final time = await showTimePicker(
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            child: child!,
          ),
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDateTime!),
        );
        if (time != null) {
          setState(() {
            selectedDateTime = selectedDateTime!.copyWith(
              hour: time.hour,
              minute: time.minute,
            );
            updateCupertinoDatePicker();
          });
        }
      },
    );
  }

  Widget addDateTimeButton() {
    return ElevatedButton(
      onPressed: () {
        // Database().addTime(_dateTime);
        Database().addTime(selectedDateTime!);
        Navigator.pop(context);
      },
      child: const Text('Add Date and Time'),
    );
  }

  Widget dateTimePicker() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ScrollConfiguration(
        behavior: MouseDragScrollBehavior(),
        child: CupertinoTheme(
          data: CupertinoThemeData(),
          child: CupertinoDatePicker(
            key: _key,
            dateOrder: DatePickerDateOrder.ymd,
            minimumDate: DateTime(1900, 1, 1),
            maximumDate: DateTime(2100, 12, 31),
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: selectedDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                selectedDateTime = newDateTime;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget loop() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 100),
      child: ListWheelScrollView.useDelegate(
        scrollBehavior: MouseDragScrollBehavior(),
        itemExtent: 24,
        childDelegate: ListWheelChildLoopingListDelegate(
          children: List<Widget>.generate(
            24,
            (index) => Text((index + 1).toString()),
          ),
        ),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedDateTime = selectedDateTime!.copyWith(
              hour: index + 1,
            );
          });
        },
      ),
    );
  }

  Widget addTimeForm() {
    return Column(
      children: [
        dateTimePicker(),
        // loop(),
        // basicDateTimeField(),
        editDateField(),
        editTimeField(),
        const SizedBox(
          height: 20,
        ),
        addDateTimeButton(),
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

class MouseDragScrollBehavior extends CupertinoScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus
      };
}
