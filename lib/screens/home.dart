import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:firebase_database/firebase_database.dart';  

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _events = [];
  Object? _votes;

  DatabaseReference currentEventsRef = FirebaseDatabase.instance.ref('CurrentEvents');
  DatabaseReference currentVotesRef = FirebaseDatabase.instance.ref('CurrentVotes');
  String uid = Auth().currentUser?.uid ?? '';
  // FirebaseDatabase database = FirebaseDatabase.instance;

  void vote(String uid, String event) async {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/$event');
    eventRef.update({
      uid: true,
    });

    //TODO: make it increment total
  }

  @override
  void initState() {
    super.initState();
    currentEventsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value ?? {};
      List<String> keys = [];
      (data as Map).forEach((key, _) {
        keys.add(key);
      });
      setState(() {
        _events = keys;
      });
    });

    currentVotesRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print('update $data');
      setState(() {
        _votes = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: Text('Test ${_events.toString()} $_votes'),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.tertiary,
                  child: TextButton(
                    onPressed: () {
                      vote(uid, 'Bocchi');
                    },
                    child: const Text('Vote'),
                  ),
                ),
              ],
            );
          }
          return Container(
            height: 200,
            color: Colors.purple[(((index%16)-7).abs()+1)*100]
          );
        },
      )
    );
  }
}