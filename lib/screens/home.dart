import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:firebase_database/firebase_database.dart';  

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _events = 'events';
  String _votes = 'votes';

  String uid = Auth().currentUser?.uid ?? '';
  // FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference currentEventsRef = FirebaseDatabase.instance.ref('CurrentEvents');
  DatabaseReference currentVotesRef = FirebaseDatabase.instance.ref('CurrentVotes');



  void vote(String uid, String event) async {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/$event');
    _votes = (await eventRef.once(DatabaseEventType.value)).snapshot.value.toString();
    _events = (await eventRef.once(DatabaseEventType.value)).snapshot.value.toString();
    print(_votes);
    print(_events);
    eventRef.update({
      uid: true,
    });

    // TransactionResult result = await eventRef.runTransaction((value) {
    //   if (value == null) {
    //     return Transaction.abort();
    //   }


    //   eventRef.set({
    //     'total': 1,
    //     'uid': true,
    //   });
    // });
    //TODO: make it check for already voted
  }

  @override
  Widget build(BuildContext context) {

    currentEventsRef.onValue.listen((DatabaseEvent event) {
      print(event.snapshot.value);
      _events = jsonEncode(event.snapshot.value);
    });

    currentVotesRef.onValue.listen((DatabaseEvent event) async {
      print(event.snapshot.value);
      _votes = jsonEncode(event.snapshot.value);
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        foregroundColor: Colors.white,
      ),
      // body: ListView(
      //   children: [
      //     Container(
      //       height: 200,
      //       color: Theme.of(context).colorScheme.primary,
      //     ),
      //     Container(
      //       height: 200,
      //       color: Theme.of(context).colorScheme.secondary,
      //     ),
      //     Container(
      //       height: 200,
      //       color: Theme.of(context).colorScheme.tertiary,
      //     ),
      //   ],
      // ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: Text('Test $_events'),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.tertiary,
                  child: TextButton(
                    onPressed: () {
                      vote(uid, 'event1');
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