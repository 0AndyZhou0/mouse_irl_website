import 'package:mouse_irl_website/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference currentEventsRef = FirebaseDatabase.instance.ref('CurrentEvents');
  final DatabaseReference currentVotesRef = FirebaseDatabase.instance.ref('CurrentVotes');

  void vote(String uid, String event) async {
    // DatabaseReference eventRef = FirebaseDatabase.instance.ref('CurrentVotes/$event');
    DatabaseReference eventRef = currentVotesRef.child(event);
    await eventRef.update({
      uid: true,
    });

    //TODO: make it increment total
  }

  Future<Map<String, int>> getVotes() async {
    final data = await currentVotesRef.once(DatabaseEventType.value);
    Map<String, int> votes = {};
    (data as Map).forEach((event, voteslist) {
      votes[event] = (voteslist as Map).length-1;
    });
    return votes;
  }
}