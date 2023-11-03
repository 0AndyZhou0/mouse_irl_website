import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

void getEvents(ValueNotifier<List<String>> events, DateTime datetime) async {
  if (datetime.year == 2024 && datetime.month == 2 && datetime.day < 14) {
    events.value = ['TODO: Violet makes card "Need more pp from my osutop"'];
    return;
  }
  final ref = FirebaseDatabase.instance
      .ref('Events/${datetime.toString().substring(0, 10)}/event');
  // print(datetime.toString().substring(0, 10));
  final event = await ref.once(DatabaseEventType.value);
  List<String> newEvents = [];
  if (event.snapshot.value != null) {
    newEvents.add(event.snapshot.value.toString());
  }
  events.value = newEvents;
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
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  getEvents(_selectedEvents, _selectedDay!);
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
                      margin: const EdgeInsets.all(8.0),
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
