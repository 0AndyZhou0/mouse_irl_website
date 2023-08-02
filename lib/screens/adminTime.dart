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
        if (data == null) {return;}
        (data as Map).forEach((time, voteslist) {
          if (voteslist == null) {return;}
          if (DateTime.tryParse(time) == null) {return;}
          times.add(time);
        });
        setState(() {
          _times = times;
        });
      }
    });
  }

  Widget removeTime(String time) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(DateTime.parse(time).toLocal().toString().substring(0,16)),
          const Expanded(
            child: SizedBox()
          ),
          SizedBox(
            width: 90,
            child: ElevatedButton(
              onPressed: () {
                currentTimesVotesRef.child(time).remove();
              },
              child: const Text('delete'),
            ),
          ),
        ],
      ),
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
        return removeTime(_times[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Times'),
      ),
      body: listOfEvents(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddTime()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Time'),
      ),
    );
  }
}