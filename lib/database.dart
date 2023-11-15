import 'package:firebase_database/firebase_database.dart';

class Database {
  final DatabaseReference currentVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes');

  Map<String, int> _eventVotes = {};
  Map<String, int> _timesVotes = {}; //in UTC time

  Map<String, int> get eventVotes => _eventVotes;
  Map<String, int> get timesVotes => _timesVotes;

  Future<bool> isAdmin(String uid) async {
    final ref = FirebaseDatabase.instance.ref('admins');
    try {
      final event = await ref.get();
      return (event.value as Map).containsKey(uid);
    } catch (e) {
      return false;
    }
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
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Times/$time');
    await eventRef.update({
      uid: true,
    });
  }

  Future<Map<String, int>> getVotes() async {
    final data = await currentVotesRef.once(DatabaseEventType.value);
    Map<String, int> votes = {};
    (data as Map).forEach((event, voteslist) {
      votes[event] = (voteslist as Map).length - 1;
    });
    return votes;
  }

  void addEvent(String event) async {
    if (event == '') {
      return;
    }
    DatabaseReference eventRef = currentVotesRef.child('Events');
    await eventRef.update({
      event: {'exists': true}
    });
  }

  void addTime(DateTime dateTime) async {
    String dateTimeUTCWithoutSeconds =
        '${dateTime.toUtc().toString().substring(0, 16)}Z';
    DatabaseReference eventRef = currentVotesRef.child('Times');
    await eventRef.update({
      dateTimeUTCWithoutSeconds: {'exists': true}
    });
  }
}
