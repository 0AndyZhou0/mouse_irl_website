import 'package:firebase_database/firebase_database.dart';

class Database {
  final DatabaseReference currentVotesRef = FirebaseDatabase.instance.ref('CurrentVotes');

  Future<bool> isAdmin(String uid) async {
    final ref = FirebaseDatabase.instance.ref('admins');
    final event = await ref.once(DatabaseEventType.value);
    return (event.snapshot.value as Map).containsKey(uid);
  }

  void voteEvent(String uid, String event) async {
    // DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/$event');
    DatabaseReference eventRef = currentVotesRef.child(event);
    await eventRef.update({
      uid: true,
    });

    //TODO: make it increment total
  }

  void voteTime(String uid, String time) async {
    //TODO: make it store in UTC datetime
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/Times/$time');
    await eventRef.update({
      uid: true,
    });
  }

  Future<Map<String, int>> getVotes() async {
    final data = await currentVotesRef.once(DatabaseEventType.value);
    Map<String, int> votes = {};
    (data as Map).forEach((event, voteslist) {
      votes[event] = (voteslist as Map).length-1;
    });
    return votes;
  }

  void addEvent(String event) async {
    if (event == '') {return;}
    DatabaseReference eventRef = currentVotesRef.child('Events');
    await eventRef.update({
      event: {
        'exists': true
      }
    });
  }

  void addTime(DateTime dateTime) async {
    String dateTimeUTCWithoutSeconds = '${dateTime.toUtc().toString().substring(0, 16)}Z';
    DatabaseReference eventRef = currentVotesRef.child('Times');
    await eventRef.update({
      dateTimeUTCWithoutSeconds: {
        'exists': true
      }
    });
  }
}