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

  Widget alertDialogYesNoMessage(
      String title, String content, Function callback,
      {String yesText = "Yes", String cancelText = "Cancel"}) {
    return AlertDialog(title: Text(title), content: Text(content), actions: [
      TextButton(
        child: Text(yesText),
        onPressed: () {
          callback();
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text(cancelText),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ]);
  }

  Widget removeEvent(String event) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 150,
              ),
              child: Text(event)),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                // warning dialog
                showDialog(
                  context: context,
                  builder: (context) => alertDialogYesNoMessage(
                    "Clear event?",
                    "Are you sure you want to clear $event?",
                    () => currentEventsVotesRef.child(event).set(
                      {
                        'exists': 'true',
                      },
                    ),
                  ),
                );
              },
              child: const Text('clear'),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => alertDialogYesNoMessage(
                    "Delete event?",
                    "Are you sure you want to delete $event?",
                    () => currentEventsVotesRef.child(event).remove(),
                  ),
                );
              },
              child: const Text('delete'),
            ),
          ),
        ],
      ),
    );
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

  Widget listOfEvents() {
    if (_events.isEmpty) {
      return const Center(
        child: Text(
          'No events',
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 69 * 2),
      itemCount: _events.length,
      itemBuilder: (BuildContext context, int index) {
        return removeEvent(_events[index]);
      },
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
      body: listOfEvents(),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        clearAllEventsButton(),
        const SizedBox(
          height: 10,
        ),
        addEventButton(),
      ]),
    );
  }
}
