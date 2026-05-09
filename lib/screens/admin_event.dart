import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/screens/add_event.dart';
import 'package:mouse_irl_website/screens/admin_edit.dart';
import 'package:mouse_irl_website/screens/alert_dialog.dart';

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
  static const double buttonWidth = 150;

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

  Widget removeAllEvents() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          // warning dialog
          showDialog(
            context: context,
            builder: (context) => alertDialogYesNoMessage(
              context,
              "Delete all events?",
              "Are you sure you want to delete all events?",
              () => currentEventsVotesRef.remove(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        child: const Text('Delete All Events'),
      ),
    );
  }

  Widget clearAllEventsButton() {
    return SizedBox(
      width: buttonWidth,
      child: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => alertDialogYesNoMessage(
              context,
              "Clear all events?",
              "Are you sure you want to clear all events?",
              () => {
                for (String event in _events)
                  {
                    currentEventsVotesRef.child(event).set({
                      'exists': 'true',
                    })
                  }
              },
            ),
          );
        },
        icon: const Icon(Icons.clear),
        label: const Text('Clear Events'),
      ),
    );
  }

  Widget addEventButton() {
    return SizedBox(
      width: buttonWidth,
      child: FloatingActionButton.extended(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Events'),
        actions: [
          removeAllEvents(),
        ],
      ),
      body: AdminEditList(
        elements: _events,
        databaseRef: currentEventsVotesRef,
        name: 'event',
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          clearAllEventsButton(),
          const SizedBox(height: 10),
          addEventButton(),
        ],
      ),
    );
  }
}
