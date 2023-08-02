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
  List<String> _times = [];

  @override
  void initState() {
    super.initState();

    currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted){
        var data = event.snapshot.value;
        Map<String, int> votes = {};
        (data as Map).forEach((event, voteslist) {
          votes[event] = (voteslist as Map).length-1;
        });
        setState(() {
          _events = votes.keys.toList();
        });
      }
    });
    
    currentTimesVotesRef.onValue.listen((DatabaseEvent event) {
      if (mounted){
        var data = event.snapshot.value;
        Map<String, int> times = {};
        (data as Map).forEach((time, voteslist) {
          times[time] = (voteslist as Map).length-1;
        });
        setState(() {
          _times = times.keys.toList();
        });
      }
    });
  }

  Widget checkLists() {
    return Column(
      children: [
        Text('Events: $_events'),
        Text('Times: $_times'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Events'),
      ),
      body: Center(
        child: Column(
          children: [
            checkLists(),
          ],
        ),
      ),
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