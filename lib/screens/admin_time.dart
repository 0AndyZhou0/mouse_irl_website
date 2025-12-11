import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/screens/add_time.dart';
import 'package:mouse_irl_website/screens/alert_dialog.dart';

class TimesAdminPage extends StatefulWidget {
  const TimesAdminPage({super.key});

  @override
  State<TimesAdminPage> createState() => _TimesAdminPageState();
}

class _TimesAdminPageState extends State<TimesAdminPage> {
  DatabaseReference currentTimesVotesRef =
      FirebaseDatabase.instance.ref('CurrentVotes/Times');

  String uid = Auth().currentUser?.uid ?? '';
  List<String> _times = [];
  static const double buttonWidth = 150;

  @override
  void initState() {
    super.initState();

    currentTimesVotesRef.onValue.listen((DatabaseEvent time) {
      if (mounted) {
        var data = time.snapshot.value;
        List<String> times = [];
        if (data != null) {
          (data as Map).forEach((time, voteslist) {
            if (voteslist != null && DateTime.tryParse(time) != null) {
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

  // Widget alertDialogYesNoMessage(
  //     String title, String content, Function callback,
  //     {String yesText = "Yes", String cancelText = "Cancel"}) {
  //   return AlertDialog(title: Text(title), content: Text(content), actions: [
  //     TextButton(
  //       child: Text(yesText),
  //       onPressed: () {
  //         callback();
  //         Navigator.of(context).pop();
  //       },
  //     ),
  //     TextButton(
  //       child: Text(cancelText),
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //     ),
  //   ]);
  // }

  Widget removeTime(String time) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(DateTime.parse(time).toLocal().toString().substring(0, 16)),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => alertDialogYesNoMessage(
                  context,
                  "Clear time?",
                  "Are you sure you want to clear ${DateTime.parse(time).toLocal().toString().substring(0, 16)}?",
                  () => currentTimesVotesRef.child(time).set(
                    {
                      'exists': 'true',
                    },
                  ),
                ),
              );
            },
            child: const Text('clear'),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => alertDialogYesNoMessage(
                  context,
                  "Delete time?",
                  "Are you sure you want to delete ${DateTime.parse(time).toLocal().toString().substring(0, 16)}?",
                  () => currentTimesVotesRef.child(time).remove(),
                ),
              );
            },
            child: const Text('delete'),
          ),
        ],
      ),
    );
  }

  Widget removeAllTimes() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => alertDialogYesNoMessage(
              context,
              "Delete all times?",
              "Are you sure you want to delete all times?",
              () => currentTimesVotesRef.remove(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        child: const Text('Delete All Times'),
      ),
    );
  }

  Widget listOfEvents() {
    if (_times.isEmpty) {
      return const Center(
        child: Text(
          'No times',
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 69 * 3),
      itemCount: _times.length,
      itemBuilder: (BuildContext context, int index) {
        return removeTime(_times[index]);
      },
    );
  }

  void advanceTimes() {
    for (String time in _times) {
      String timeNextWeek =
          "${DateTime.parse(time).add(const Duration(days: 7)).toString().substring(0, 16)}Z";
      currentTimesVotesRef.child(time).remove();
      currentTimesVotesRef.update({
        timeNextWeek: {
          'exists': 'true',
        },
      });
    }
  }

  Widget advanceAllTimesButton() {
    return SizedBox(
      width: buttonWidth,
      child: FloatingActionButton.extended(
        heroTag: "advanceAllTimes",
        onPressed: () => showDialog(
          context: context,
          // TODO: Allow user to adjust time advanced
          builder: (context) => alertDialogYesNoMessage(
            context,
            "Advance all times?",
            "Are you sure you want to advance all times by one week?",
            advanceTimes,
            yesText: "Confirm",
            cancelText: "Cancel",
          ),
        ),
        label: const Text('Advance Times'),
      ),
    );
  }

  Widget clearAllTimesButton() {
    return SizedBox(
      width: buttonWidth,
      child: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => alertDialogYesNoMessage(
              context,
              "Clear all times?",
              "Are you sure you want to clear all times?",
              () => {
                for (String time in _times)
                  {
                    currentTimesVotesRef.child(time).set({
                      'exists': 'true',
                    })
                  }
              },
            ),
          );
        },
        icon: const Icon(Icons.clear),
        label: const Text('Clear Times'),
      ),
    );
  }

  Widget addTimeButton() {
    return SizedBox(
      width: buttonWidth,
      child: FloatingActionButton.extended(
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
          advanceAllTimesButton(),
          const SizedBox(
            height: 10,
          ),
          clearAllTimesButton(),
          const SizedBox(
            height: 10,
          ),
          addTimeButton(),
        ],
      ),
    );
  }
}
