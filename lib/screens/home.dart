import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference currentVotesRef = FirebaseDatabase.instance.ref('CurrentVotes');
  
  String uid = Auth().currentUser?.uid ?? '';
  List<String> _events = [];
  Map<String, int> _votes = {};

  @override
  void initState() {
    super.initState();

    currentVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted){
        var data = event.snapshot.value;
        Map<String, int> votes = {};
        (data as Map).forEach((event, voteslist) {
          votes[event] = (voteslist as Map).length-1;
        });
        setState(() {
          _events = votes.keys.toList();
          _votes = votes;
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

  void vote(String uid, String event) async {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/$event');
    await eventRef.update({
      uid: true,
    });
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
