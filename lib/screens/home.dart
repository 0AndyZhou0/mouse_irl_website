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
    if (_timesVotes.isEmpty || _eventVotes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get most voted time
    String mostVotedTime = _timesVotes.keys.first;
    _timesVotes.forEach((key, value) {
      if (value > _timesVotes[mostVotedTime]!) {
        mostVotedTime = key.toString();
      }
    });

    var localTime = DateTime.parse(mostVotedTime).toLocal();

    // Get most voted event
    String mostVotedEvent = _eventVotes.keys.first;
    _eventVotes.forEach((key, value) {
      if (value > _eventVotes[mostVotedEvent]!) {
        mostVotedEvent = key;
      }
    });

    return Container(
      // color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        '$mostVotedEvent,\n${DateFormat('EEEE, MMMM d, y, h:mm a').format(localTime)}',
        style: const TextStyle(
          fontSize: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  void voteEvent(String event) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Events/$event');
    await eventRef.update({
      uid: true,
    });
  }

  void unvoteEvent(String event) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Events/$event');
    await eventRef.update({
      uid: null,
    });
  }

  // Vote/Unvote Event
  Widget voteEventsButton(String event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Text('$event: ${_eventVotes[event]}'),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if (_eventsVoted.contains(event)) {
                  unvoteEvent(event);
                } else {
                  voteEvent(event);
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_eventsVoted.contains(event)) {
                    return const Text('Voted');
                  } else {
                    return const Text('Vote for Event');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void voteTime(String dateTime) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Times/$dateTime');
    await eventRef.update({
      uid: true,
    });
  }

  void unvoteTime(String dateTime) async {
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

    // Vote/Unvote Card
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            // Text('$localTimeStr - $localendTimeStr: ${_timesVotes[dateTime]}'),
            Text('$localTimeStr: ${_timesVotes[dateTime]}'),
            const Expanded(child: SizedBox()),
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  if (_timesVoted.contains(dateTime)) {
                    unvoteTime(dateTime);
                  } else {
                    voteTime(dateTime);
                  }
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (_timesVoted.contains(dateTime)) {
                      return const Text('Voted');
                    } else {
                      return const Text('Vote for Time');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventVoteList() {
    return Column(
      children: [
        Text(
          'Events',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _eventVotes.length,
          itemBuilder: (context, index) {
            // if (uid == '' && index == 0) {
            //   return Container(
            //     padding: const EdgeInsets.only(left: 5.0),
            //     height: 20,
            //     child: const Text('Sign in to vote for events!'),
            //   );
            // }
            if (index < _eventVotes.length && uid != '') {
              return Container(
                  child: voteEventsButton(_eventVotes.keys.elementAt(index)));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget timeVoteList() {
    return Column(
      children: [
        Text(
          'Times',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
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
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget border(Widget child) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }

  Widget singleColumn() {
    return ListView(
      physics: const ScrollPhysics(),
      children: [
        eventView(),
        eventVoteList(),
        timeVoteList(),
      ],
    );
  }

  Widget doubleColumn() {
    return ListView(
      children: [
        eventView(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: border(eventVoteList()),
            ),
            Expanded(
              child: border(timeVoteList()),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return singleColumn();
          } else {
            return doubleColumn();
          }
        },
      ),
    );
  }
}
