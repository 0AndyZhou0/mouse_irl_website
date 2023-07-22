import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference currentEventsVotesRef = FirebaseDatabase.instance.ref('CurrentVotes/Events');
  DatabaseReference currentTimesVotesRef = FirebaseDatabase.instance.ref('CurrentVotes/Times');
  
  String uid = Auth().currentUser?.uid ?? '';
  List<String> _events = [];
  List<String> _times = [];
  Map<String, int> _eventVotes = {};
  Map<String, int> _timesVotes = {};

  @override
  void initState() {
    super.initState();

    currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted){
        var data = event.snapshot.value;
        Map<String, int> votes = {};
        (data as Map).forEach((event, voteslist) {
          votes[event] = (voteslist as Map).length-1;
        });
        setState(() {
          _events = votes.keys.toList();
          _eventVotes = votes;
        });
      }
    });
    
    currentTimesVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted){
        var data = event.snapshot.value;
        Map<String, int> times = {};
        (data as Map).forEach((time, voteslist) {
          times[time] = (voteslist as Map).length-1;
        });
        setState(() {
          _times = times.keys.toList();
          _timesVotes = times;
        });
      }
    });
  }

  void insertDatetime(DateTime datetime) {
    DatabaseReference datetimeRef = FirebaseDatabase.instance.ref('Events');
    String date = datetime.toString().substring(0, 10);
    String time = datetime.toString().substring(11, 16);
    datetimeRef.update({
      date: {
        'time': time,
        'event': 'Bocchi',
      },
    });
}

  Widget datetimeButton() {
    return Column(
      children: [
        const Text('insert time'),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            insertDatetime(DateTime.now());
          },
          child: const Text('insert time'),
        ),
      ],
    );
  }

  String convertToTime(DateTime time) {
    String weekday = 'Unknown';
    switch (time.weekday) {
      case 1:
        weekday = 'Monday';
        break;
      case 2:
        weekday = 'Tuesday';
        break;
      case 3:
        weekday = 'Wednesday';
        break;
      case 4:
        weekday = 'Thursday';
        break;
      case 5:
        weekday = 'Friday';
        break;
      case 6:
        weekday = 'Saturday';
        break;
      case 7:
        weekday = 'Sunday';
        break;
      default:
        break;
    }
    String month = 'Unknown';
    switch (time.month) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'Febuary';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'November';
        break;
      case 12:
        month = 'December';
        break;
      default:
        break;
    }
    return '$weekday, $month ${time.day}\n${time.hour}:${time.minute} ${time.timeZoneName}';
  }

  Widget eventView(String event, DateTime time) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        '$event\n${convertToTime(time)}',
        style: const TextStyle(
          fontSize: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  void voteEvent(String uid, String event) async {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/Events/$event');
    await eventRef.update({
      uid: true,
    });
  }

  void voteTime(String uid, String time) async {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/Times/$time');
    await eventRef.update({
      uid: true,
    });
  }

  Widget voteEventsButton(String event) {
    return Row(
      children: [
        const SizedBox(width: 10,),
        Text('$event: ${_eventVotes[event]}'),
        const SizedBox(width: 10,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            voteEvent(uid, event);
          },
          child: Text('Vote for $event'),
        ),
      ],
    );
  }

  Widget voteTimesButton(String time) {
    var utcTime = DateTime.utc(2023, 7, 21, int.parse(time), 0);
    var localTime = utcTime.toLocal();
    var localTimeStr = DateFormat('hh:mm a').format(localTime);
    var localendTimeStr = DateFormat('hh:mm a').format(localTime.add(const Duration(hours: 2)));
    return Row(
      children: [
        const SizedBox(width: 10,),
        Text('$localTimeStr - $localendTimeStr: ${_timesVotes[time]}'),
        const SizedBox(width: 10,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            voteTime(uid, time);
          },
          child: Text('Vote for $localTimeStr - $localendTimeStr'),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                eventView('Bocchi', DateTime(2023, 7, 15, 9, 43)),
                Container(
                  color: Theme.of(context).colorScheme.secondary,
                  width: double.infinity,
                  child: const Text(
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                    ),
                    'The time above is in the past',
                  ),
                ),
              ],
            );
          }
          if (index <= _events.length && uid != '') {
            return Column(
              children: [
                voteEventsButton(_events[index-1]),
                const SizedBox(height: 10,),
              ],
            );
          }
          if (index < _times.length + _events.length && uid != '') {
            return Column(
              children: [
                voteTimesButton(_times[index-_events.length-1]),
                const SizedBox(height: 10,),
              ],
            );
          }
          return Container(
            height: 200,
            color: Colors.purple[(((index%16)-7).abs()+1)*100]
          );
        },
      )
    );
  }
}
