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
  DatabaseReference currentEventsVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes/Events');
  DatabaseReference currentTimesVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes/Times');

  String uid = Auth().currentUser?.uid ?? '';
  Map<String, int> _eventVotes = {};
  Map<String, int> _timesVotes = {}; //in UTC time
  List<String> _eventsVoted = [];
  List<String> _timesVoted = [];

  @override
  void initState() {
    super.initState();

    currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted) {
        var data = event.snapshot.value;
        Map<String, int> eventVotes = {};
        List<String> eventsVoted = [];
        if (data != null) {
          (data as Map).forEach((event, voteslist) {
            if (voteslist != null) {
              (voteslist as Map).forEach((id, vote) {
                if (vote == true && id == uid) {
                  eventsVoted.add(event);
                }
              });
              eventVotes[event] = voteslist.length - 1;
            }
          });
        }
        setState(() {
          _eventVotes = eventVotes;
          _eventsVoted = eventsVoted;
        });
      }
    });

    currentTimesVotesRef.onValue.listen((DatabaseEvent time) {
      if (mounted) {
        var data = time.snapshot.value;
        Map<String, int> timeVotes = {};
        List<String> timesVoted = [];
        if (data != null) {
          (data as Map).forEach((time, voteslist) {
            if (voteslist != null && DateTime.tryParse(time) != null) {
              (voteslist as Map).forEach((id, vote) {
                if (vote == true && id == uid) {
                  timesVoted.add(time);
                }
              });
              timeVotes[time] = voteslist.length - 1;
            }
          });
        }
        setState(() {
          _timesVotes = timeVotes;
          _timesVoted = timesVoted;
        });
      }
    });
  }

  Widget eventView() {
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
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Events/$event');
    await eventRef.update({
      uid: true,
    });
  }

  void unvoteEvent(String uid, String event) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Events/$event');
    await eventRef.update({
      uid: null,
    });
  }

  Widget voteEventsButton(String event) {
    // Unvote Card
    if (_eventsVoted.contains(event)) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            children: [
              Text('$event: ${_eventVotes[event]}'),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: () {
                  unvoteEvent(uid, event);
                },
                child: const Text('Voted'),
              ),
            ],
          ),
        ),
      );
    }
    //Vote Card
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
              child: const Text('Vote for Event'),
            ),
          ],
        ),
      ),
    );
  }

  void voteTime(String uid, String dateTime) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Times/$dateTime');
    await eventRef.update({
      uid: true,
    });
  }

  void unvoteTime(String uid, String dateTime) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Times/$dateTime');
    await eventRef.update({
      uid: null,
    });
  }

  Widget voteTimesButton(String dateTime) {
    var localTime = DateTime.parse(dateTime).toLocal();
    var localTimeStr = DateFormat('E, MMMM d, hh:mm a').format(localTime);
    // var localendTimeStr = DateFormat('hh:mm a').format(localTime.add(const Duration(hours: 2)));

    // Unvote Card
    if (_timesVoted.contains(dateTime)) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                  unvoteTime(uid, dateTime);
                },
                child: const Text('Voted'),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
      ),
    );
  }

  Widget singleColumn() {
    return ListView(
      physics: const ScrollPhysics(),
      children: [
        Container(child: eventView()),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _eventVotes.length,
          itemBuilder: (context, index) {
            if (index < _eventVotes.length && uid != '') {
              return Container(
                  child: voteEventsButton(_eventVotes.keys.elementAt(index)));
            }
            return const SizedBox(
              height: 50,
              child: Text(':3'),
            );
          },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _timesVotes.length,
          itemBuilder: (context, index) {
            if (index < _timesVotes.length && uid != '') {
              return Container(
                  child: voteTimesButton(_timesVotes.keys.elementAt(index)));
            }
            return const SizedBox(
              height: 50,
              child: Text(':3'),
            );
          },
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
      body: singleColumn(),
    );
  }
}
