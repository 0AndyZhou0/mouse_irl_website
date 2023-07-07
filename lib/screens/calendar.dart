import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

Future<List<String>> getEvents(DateTime day) async {
  
  return await <String>['hi'];
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  ValueNotifier<List<String>> _selectedEvents = ValueNotifier<List<String>>([]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected:(selectedDay, focusedDay) {
              setState(() {
                if (!isSameDay(_selectedDay, selectedDay)){
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents.value = <String>["test1", "test2", "test3"];
                  if (selectedDay.month != DateTime.july) {
                    _selectedEvents.value = <String>["test1"];
                  }
                }
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _selectedEvents,
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text('${value[index]}'),
                        onTap: () => print('tapped ${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}