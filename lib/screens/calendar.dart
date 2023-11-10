import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

Map<String, Map<String, List<String>>> events = {
  'singleEvents': {},
  'yearlyEvents': {},
  'monthlyEvents': {},
  'weeklyEvents': {},
};
// singleEvents datetime(yyyy-mm-dd) : events
// yearlyEvents datetime(mm-dd) : events
// monthlyEvents day(int) : events
// weeklyEvents weekday(int) : events

Future<Map<String, List<String>>> getEventsFromDatabaseBasedOnRef(
    String ref) async {
  final events = await FirebaseDatabase.instance.ref(ref).get();
  Map<String, List<String>> eventsMap = {};
  if (events.exists) {
    (events.value! as Map).forEach((key, value) {
      eventsMap[key] = (value as List).cast<String>();
    });
  }
  return eventsMap;
}

Future<Map<String, Map<String, List<String>>>> getEventsFromDatabase() async {
  Map<String, Map<String, List<String>>> eventsFromDatabase = {};
  eventsFromDatabase['singleEvents'] =
      await getEventsFromDatabaseBasedOnRef('SingleEvents');
  eventsFromDatabase['yearlyEvents'] =
      await getEventsFromDatabaseBasedOnRef('YearlyEvents');
  eventsFromDatabase['monthlyEvents'] =
      await getEventsFromDatabaseBasedOnRef('MonthlyEvents');
  eventsFromDatabase['weeklyEvents'] =
      await getEventsFromDatabaseBasedOnRef('WeeklyEvents');
  return eventsFromDatabase;
}

void updateEvents(ValueNotifier<List<String>> events, DateTime datetime) {
  events.value = getEvents(datetime);
}

List<String> getEvents(DateTime datetime) {
  List<String> newEvents = [];

  if (datetime.year == 2024 && datetime.month == 2 && datetime.day < 14) {
    newEvents = ['TODO: Violet makes card "Need more pp from my osutop"'];
  }

  //single events
  if (events['singleEvents']!
      .containsKey(datetime.toString().substring(0, 10))) {
    newEvents
        .addAll(events['singleEvents']![datetime.toString().substring(0, 10)]!);
  }

  //yearly events
  if (events['yearlyEvents']!
      .containsKey(datetime.toString().substring(5, 10))) {
    newEvents
        .addAll(events['yearlyEvents']![datetime.toString().substring(5, 10)]!);
  }

  //monthly events
  if (events['monthlyEvents']!.containsKey(datetime.day.toString())) {
    newEvents.addAll(events['monthlyEvents']![datetime.day.toString()]!);
  }

  //weekly events
  if (events['weeklyEvents']!.containsKey(datetime.weekday.toString())) {
    newEvents.addAll(events['weeklyEvents']![datetime.weekday.toString()]!);
  }

  return newEvents;
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ValueNotifier<List<String>> _selectedEvents =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    getEventsFromDatabase().then((results) {
      setState(() {
        events = results;
      });
    });
    super.initState();
  }

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
                  updateEvents(_selectedEvents, _selectedDay!);
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
            eventLoader: (day) {
              return getEvents(day);
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
                        title: Text(value[index]),
                        // onTap: () => print('tapped ${value[index]}'),
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
