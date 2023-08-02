import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/screens/addEvent.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  DatabaseReference currentEventsVotesRef = FirebaseDatabase.instance.ref('CurrentVotes/Events');
  DatabaseReference currentTimesVotesRef = FirebaseDatabase.instance.ref('CurrentVotes/Times');
  
  String uid = Auth().currentUser?.uid ?? '';
  List<String> _events = [];

  @override
  void initState() {
    super.initState();

    currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted){
        var data = event.snapshot.value;
        Map<String, int> votes = {};
        (data as Map).forEach((event, voteslist) {
          if (voteslist == null) {return;}
          votes[event] = (voteslist as Map).length-1;
        });
        setState(() {
          _events = votes.keys.toList();
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
          const Expanded(
            child: SizedBox()
          ),
          SizedBox(
            width: 90,
            child: ElevatedButton(
              onPressed: () {
                currentEventsVotesRef.child(event).remove();
              },
              child: const Text('delete'),
            ),
          ),
        ],
      ),
    );
  }

  Widget listOfEvents() {
    if (_events.isEmpty) {
      return const Center(
        child: Text('No events',),
      );
    }
    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (BuildContext context, int index) {
        if(_events.isEmpty) {
          return const Text('No events');
        }
        return removeEvent(_events[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Events'),
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