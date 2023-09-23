import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/screens/addTime.dart';

class TimesAdminPage extends StatefulWidget {
  const TimesAdminPage({super.key});

  @override
  State<TimesAdminPage> createState() => _TimesAdminPageState();
}

class _TimesAdminPageState extends State<TimesAdminPage> {
  DatabaseReference currentTimesVotesRef = FirebaseDatabase.instance.ref('CurrentVotes/Times');
  
  String uid = Auth().currentUser?.uid ?? '';
  List<String> _times = [];

  @override
  void initState() {
    super.initState();

    currentTimesVotesRef.onValue.listen((DatabaseEvent time) {
      if (mounted){
        var data = time.snapshot.value;
        List<String> times = [];
        if (data != null) {
          (data as Map).forEach((time, voteslist) {
            if (voteslist != null && DateTime.tryParse(time) != null) {
              print(time);
              times.add(time);
            }
          });
        }
        setState(() {
          _times = times;
        });
      }
    });
  }

  Widget timeItem(String time) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(DateTime.parse(time).toLocal().toString().substring(0,16)),
          const Expanded(
            child: SizedBox()
          ),
          ElevatedButton(
            onPressed: () {
              currentTimesVotesRef.child(time).set({
                'exists': 'true',
              });
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
              child: Text(
                'clear',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10,),
          ElevatedButton(
            onPressed: () {
              currentTimesVotesRef.child(time).remove();
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
              child: Text(
                'delete',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget removeAllTimes() {
    return ElevatedButton(
      onPressed: () {
        currentTimesVotesRef.remove();
      },
      child: const Text('Delete All Times'),
    );
  }

  void advanceTime(String time) {
    String newTime = "${DateTime.parse(time).add(const Duration(days: 7)).toString().substring(0, 16)}Z";
    currentTimesVotesRef.child(time).remove();
    currentTimesVotesRef.update({
      newTime: {
        'exists': true
      }
    });
  }

  Widget advanceAllTimes() {
    return FloatingActionButton.extended(
      heroTag: "advanceAllTimes",
      onPressed: () {
        showDialog(
          context: context, 
          // TODO: Allow user to adjust time advance
          builder: (context) => AlertDialog(
            title: const Text("Advance All Times \nBy 1 Week?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  for (String time in _times) {
                    advanceTime(time);
                  }
                  Navigator.pop(context);
                }, 
                child: const Text("Confirm"),
              ),
            ],
          ),
        );
      },
      label: const Text('Advance Times'),
    );
  }

  Widget listOfEvents() {
    if (_times.isEmpty) {
      return const Center(
        child: Text('No times',),
      );
    }
    return ListView.builder(
      itemCount: _times.length,
      itemBuilder: (BuildContext context, int index) {
        return timeItem(_times[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Times'),
        actions: [
          removeAllTimes(),
        ],
      ),
      body: listOfEvents(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          advanceAllTimes(),
          const SizedBox(height: 10,),
          FloatingActionButton.extended(
            heroTag: "addTimePage",
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const AddTime()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Time'),
          ),
        ],
      ),
    );
  }
}