import 'package:firebase_database/firebase_database.dart';
import 'package:mouse_irl_website/auth.dart';

class Database {
  final DatabaseReference currentVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes');

  static final Database _instance = Database._internal();
  factory Database() => _instance;

  DatabaseReference currentEventsVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes/Events');
  DatabaseReference currentTimesVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes/Times');

  Database._internal() {
    // page doesn't update on change

    currentEventsVotesRef.onValue.listen((DatabaseEvent event) {
      print("checking events");
      var data = event.snapshot.value;
      Map<String, int> eventVotes = {};
      Set<String> eventsVoted = {};
      if (data != null) {
        (data as Map).forEach((event, voteslist) {
          if (voteslist != null) {
            (voteslist as Map).forEach((id, vote) {
              if (vote == true && id == Auth().currentUser!.uid) {
                eventsVoted.add(event);
              }
            });
            eventVotes[event] = voteslist.length - 1;
          }
        });
        this.eventVotes = eventVotes;
        this.eventsVoted = eventsVoted;
      }
    });

    currentTimesVotesRef.onValue.listen((DatabaseEvent time) {
      var data = time.snapshot.value;
      timeVotes = {};
      timesVoted = {};
      if (data != null) {
        (data as Map).forEach((time, voteslist) {
          if (voteslist != null && DateTime.tryParse(time) != null) {
            (voteslist as Map).forEach((id, vote) {
              if (vote == true && id == Auth().currentUser!.uid) {
                timesVoted.add(time);
              }
            });
            timeVotes[time] = voteslist.length - 1;
          }
        });
      }
    });
  }

  Map<String, int> eventVotes = {};
  Map<String, int> timeVotes = {}; //in UTC time
  Set<String> eventsVoted = {};
  Set<String> timesVoted = {};

  Future<bool> isAdmin(String uid) async {
    final ref = FirebaseDatabase.instance.ref('admins');
    try {
      final event = await ref.once();
      return (event.snapshot.value as Map).containsKey(uid);
    } catch (e) {
      return false;
    }
  }

  void voteEvent(String event) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Events/$event');
    await eventRef.update({
      Auth().currentUser!.uid: true,
    });
  }

  void unvoteEvent(String event) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Events/$event');
    await eventRef.update({
      Auth().currentUser!.uid: null,
    });
  }

  void voteTime(String dateTime) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Times/$dateTime');
    await eventRef.update({
      Auth().currentUser!.uid: true,
    });
  }

  void unvoteTime(String dateTime) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref('CurrentVotes/Times/$dateTime');
    await eventRef.update({
      Auth().currentUser!.uid: null,
    });
  }

  Future<void> getVotes() async {
    final data = await currentVotesRef.once(DatabaseEventType.value);
    Map<String, int> votes = {};
    (data as Map).forEach((event, voteslist) {
      votes[event] = (voteslist as Map).length - 1;
    });
    eventVotes = votes;
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
