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
  Map<String, int> _timesVotes = {}; //in UTC time

  @override
  void initState() {
    super.initState();

    currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted){
        var data = event.snapshot.value;
        Map<String, int> eventVotes = {};
        if (data != null) {
          (data as Map).forEach((event, voteslist) {
            if (voteslist != null) {
              eventVotes[event] = (voteslist as Map).length-1;  
            }
          });
        }
        setState(() {
          _events = eventVotes.keys.toList();
          _eventVotes = eventVotes;
        });
      }
    });
    
    currentTimesVotesRef.onValue.listen((DatabaseEvent time) {
      if (mounted){
        var data = time.snapshot.value;
        Map<String, int> timeVotes = {};
        if (data != null) {
          (data as Map).forEach((time, voteslist) {
            if (voteslist != null && DateTime.tryParse(time) != null) {
              timeVotes[time] = (voteslist as Map).length-1;
            }
          });
        }
        setState(() {
          _times = timeVotes.keys.toList();
          _timesVotes = timeVotes;
        });
      }
    });
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
    // TODO: make parse datetime in the future
    String? mostVotedTime;
    _timesVotes.forEach((key, value) {
      if (mostVotedTime == null) {
        mostVotedTime = key.toString();
      } else if (value > _timesVotes[mostVotedTime]!) {
        mostVotedTime = key.toString();
      }
    });

    if (mostVotedTime == null) {
      return Container();
    }

    var localTime = DateTime.parse(mostVotedTime!).toLocal();

    String? mostVotedEvent;
    _eventVotes.forEach((key, value) {
      if (mostVotedEvent == null) {
        mostVotedEvent = key;
      } else if (value > _eventVotes[mostVotedEvent]!) {
        mostVotedEvent = key;
      }
    });

    if (mostVotedEvent == null) {
      return Container();
    }

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        '$mostVotedEvent,\n${DateFormat('EEEE, MMMM d, y, h:mm a').format(localTime)}',
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

  Widget voteEventsButton(String event) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('$event: ${_eventVotes[event]}'),
          const Expanded(child: SizedBox()),
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
      ),
    );
  }

  void voteTime(String uid, String dateTime) async {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/Times/$dateTime');
    await eventRef.update({
      uid: true,
    });
  }

  Widget voteTimesButton(String dateTime) {
    // TODO: make parse datetime in the future
    var localTime = DateTime.parse(dateTime).toLocal();
    var localTimeStr = DateFormat('E, MMMM d, hh:mm a').format(localTime);
    // var localendTimeStr = DateFormat('hh:mm a').format(localTime.add(const Duration(hours: 2)));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text('$localTimeStr - $localendTimeStr: ${_timesVotes[dateTime]}'),
          Text('$localTimeStr: ${_timesVotes[dateTime]}'),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            onPressed: () {
              voteTime(uid, dateTime);
            },
            child: const Text('Vote for Time'),
          ),
        ],
      ),
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
                const SizedBox(height: 10,),
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
          if (index <= _times.length + _events.length && uid != '') {
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
