import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mouse_irl_website/database.dart';
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

  double? colWidth;

  @override
  void initState() {
    super.initState();

    // Database().getVotes();
    // print(Database().eventVotes);

    //   currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
    //     if (mounted) {
    //       var data = event.snapshot.value;
    //       Map<String, int> eventVotes = {};
    //       Set<String> eventsVoted = {};
    //       if (data != null) {
    //         (data as Map).forEach((event, voteslist) {
    //           if (voteslist != null) {
    //             (voteslist as Map).forEach((id, vote) {
    //               if (vote == true && id == uid) {
    //                 eventsVoted.add(event);
    //               }
    //             });
    //             eventVotes[event] = voteslist.length - 1;
    //           }
    //         });
    //       }
    //       setState(() {
    //         Database().eventVotes = eventVotes;
    //         Database().eventsVoted = eventsVoted;
    //       });
    //     }
    //   });

    //   currentTimesVotesRef.onValue.listen((DatabaseEvent time) {
    //     if (mounted) {
    //       var data = time.snapshot.value;
    //       Map<String, int> timeVotes = {};
    //       Set<String> timesVoted = {};
    //       if (data != null) {
    //         (data as Map).forEach((time, voteslist) {
    //           if (voteslist != null && DateTime.tryParse(time) != null) {
    //             (voteslist as Map).forEach((id, vote) {
    //               if (vote == true && id == uid) {
    //                 timesVoted.add(time);
    //               }
    //             });
    //             timeVotes[time] = voteslist.length - 1;
    //           }
    //         });
    //       }
    //       setState(() {
    //         Database().timeVotes = timeVotes;
    //         Database().timesVoted = timesVoted;
    //       });
    //     }
    //   });
  }

  Widget eventView() {
    if (Database().timeVotes.isEmpty || Database().eventVotes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get most voted time
    String mostVotedTime = Database().timeVotes.keys.first;
    Database().timeVotes.forEach((key, value) {
      if (value > Database().timeVotes[mostVotedTime]!) {
        mostVotedTime = key.toString();
      }
    });

    var localTime = DateTime.parse(mostVotedTime).toLocal();

    // Get most voted event
    String mostVotedEvent = Database().eventVotes.keys.first;
    Database().eventVotes.forEach((key, value) {
      if (value > Database().eventVotes[mostVotedEvent]!) {
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

  // Vote/Unvote Event
  Widget voteEventsButton(String event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: colWidth! - 100,
              ),
              child: Text(event),
            ),
            const Expanded(child: SizedBox()),
            Text('${Database().eventVotes[event]}'),
            IconButton(
              onPressed: () {
                if (Database().eventsVoted.contains(event)) {
                  Database().unvoteEvent(event);
                } else {
                  Database().voteEvent(event);
                }
              },
              tooltip:
                  Database().eventsVoted.contains(event) ? 'Unvote' : 'Vote',
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              color: Theme.of(context).colorScheme.primary,
              icon: Database().eventsVoted.contains(event)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
            ),
          ],
        ),
      ),
    );
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
            Text(localTimeStr),
            const Expanded(child: SizedBox()),
            Text('${Database().timeVotes[dateTime]}'),
            IconButton(
              onPressed: () {
                if (Database().timesVoted.contains(dateTime)) {
                  Database().unvoteTime(dateTime);
                } else {
                  Database().voteTime(dateTime);
                }
              },
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              tooltip:
                  Database().timesVoted.contains(dateTime) ? 'Unvote' : 'Vote',
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              color: Theme.of(context).colorScheme.primary,
              icon: Database().timesVoted.contains(dateTime)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
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
          itemCount: Database().eventVotes.length,
          itemBuilder: (context, index) {
            // if (uid == '' && index == 0) {
            //   return Container(
            //     padding: const EdgeInsets.only(left: 5.0),
            //     height: 20,
            //     child: const Text('Sign in to vote for events!'),
            //   );
            // }
            if (index < Database().eventVotes.length && uid != '') {
              return Container(
                  child: voteEventsButton(
                      Database().eventVotes.keys.elementAt(index)));
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
          itemCount: Database().timeVotes.length,
          itemBuilder: (context, index) {
            if (index < Database().timeVotes.length && uid != '') {
              return Container(
                  child: voteTimesButton(
                      Database().timeVotes.keys.elementAt(index)));
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
            colWidth = constraints.maxWidth - 16;
            return singleColumn();
          } else {
            colWidth = constraints.maxWidth / 2 - 16;
            return doubleColumn();
          }
        },
      ),
    );
  }
}
