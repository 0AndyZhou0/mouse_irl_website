import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mouse_irl_website/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = Auth().currentUser?.uid ?? '';
  List<String> _events = [];
  Map<String, int> _votes = new Map<String, int>();

  void vote(String uid, String event) async {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/$event');
    await eventRef.update({
      uid: true,
    });

    //TODO: make it increment total
  }

  void initEvents() async {
    DatabaseReference currentEventsRef = FirebaseDatabase.instance.ref('CurrentEvents');
    final eventsData = (await currentEventsRef.get()).value;
    List<String> events = [];
    (eventsData as Map).forEach((key, _) {
      events.add(key);
    });
    setState(() {
      _events = events;
    });

    DatabaseReference currentVotesRef = FirebaseDatabase.instance.ref('CurrentVotes');
    final votesData = (await currentVotesRef.get()).value;
    Map<String, int> votes = {};
    (votesData as Map).forEach((event, voteslist) {
      votes[event] = (voteslist as Map).length-1;
    });
    setState(() {
      _votes = votes;
    });
  }
  
  @override
  void initState() {
    super.initState();

    // initEvents();

    DatabaseReference currentEventsRef = FirebaseDatabase.instance.ref('CurrentEvents');
    currentEventsRef.onValue.listen((DatabaseEvent event) {
      var data = event.snapshot.value ?? {};
      List<String> events = [];
      (data as Map).forEach((key, _) {
        events.add(key);
      });
      if (mounted){
        setState(() {
          _events = events;
        });
      }
    });

    DatabaseReference currentVotesRef = FirebaseDatabase.instance.ref('CurrentVotes');
    currentVotesRef.onValue.listen((DatabaseEvent event) {
      var data = event.snapshot.value;
      Map<String, int> votes = {};
      (data as Map).forEach((event, voteslist) {
        votes[event] = (voteslist as Map).length-1;
      });
      if (mounted){
        setState(() {
          _votes = votes;
        });
      }
    });

    //TODO: make it update based on children added and removed

    // currentVotesRef.onChildAdded.listen((vote) {
    //   if (vote.snapshot.exists) {
    //     String event = vote.snapshot.key!;
    //     int totalVotes = (vote.snapshot.value as Map).length - 1;
    //     _votes[event] = totalVotes;
    //   }
    // });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

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

  Widget voteButton(String event) {
    return Column(
      children: [
        Text('$event: ${_votes[event]}'),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            vote(uid, event);
          },
          child: Text('Vote for $event'),
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
          if (index == 0 && uid != '') {
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
                    'The time above is made up',
                  ),
                ),
                // Container(
                //   height: 200,
                //   width: double.infinity,
                //   color: Theme.of(context).colorScheme.primary,
                //   child: Text('Test ${_events.toString()} $_votes'),
                // ),
              ],
            );
          }
          if (index <= _events.length && uid != '') {
            return voteButton(_events[index-1]);
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
