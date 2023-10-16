import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/screens/add_event.dart';

class EventsAdminPage extends StatefulWidget {
  const EventsAdminPage({super.key});

  @override
  State<EventsAdminPage> createState() => _EventsAdminPageState();
}

class _EventsAdminPageState extends State<EventsAdminPage> {
  DatabaseReference currentEventsVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes/Events');

  String uid = Auth().currentUser?.uid ?? '';
  List<String> _events = [];

  @override
  void initState() {
    super.initState();

    currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted) {
        var data = event.snapshot.value;
        List<String> eventVotes = [];
        if (data != null) {
          (data as Map).forEach((event, voteslist) {
            if (voteslist != null) {
              eventVotes.add(event);
            }
          });
        }
        setState(() {
          _events = eventVotes;
        });
      }
    });
  }

  Widget removeEvent(String event) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(event),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () {
              currentEventsVotesRef.child(event).set({
                'exists': 'true',
              });
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
              child: Text(
                'clear',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              currentEventsVotesRef.child(event).remove();
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
              child: Text(
                'delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget removeAllEvents() {
    return ElevatedButton(
      onPressed: () {
        currentEventsVotesRef.remove();
      },
      child: const Text('Delete All Events'),
    );
  }

  Widget listOfEvents() {
    if (_events.isEmpty) {
      return const Center(
        child: Text(
          'No events',
        ),
      );
    }
    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (BuildContext context, int index) {
        return removeEvent(_events[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Events'),
        actions: [
          removeAllEvents(),
        ],
      ),
      body: listOfEvents(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEvent()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
      ),
    );
  }
}
