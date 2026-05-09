import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/configs/mouse.dart';
import 'package:mouse_irl_website/screens/alert_dialog.dart';

class AdminEditList extends StatefulWidget {
  static String defaultParse(String element) => element;

  const AdminEditList({
    super.key,
    required this.elements,
    required this.databaseRef,
    this.name = "Element",
    this.parseElement = defaultParse,
    this.buttonSize = 60,
  });

  final List<String> elements;
  final DatabaseReference databaseRef;
  final String name;
  final Function(String) parseElement;
  final double buttonSize;

  @override
  State<AdminEditList> createState() => _AdminEditListState();
}

class _AdminEditListState extends State<AdminEditList> {
  String uid = Auth().currentUser?.uid ?? '';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

  Widget singleListElement(String element) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 150,
            ),
            child: Text(widget.parseElement(element)),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: widget.buttonSize,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                // warning dialog
                showDialog(
                  context: context,
                  builder: (context) => alertDialogYesNoMessage(
                    context,
                    "Clear ${widget.name}?",
                    "Are you sure you want to clear ${widget.parseElement(element)}?",
                    () => widget.databaseRef.child(element).set(
                      {
                        'exists': 'true',
                      },
                    ),
                  ),
                );
              },
              child: const Text('clear'),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: widget.buttonSize,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => alertDialogYesNoMessage(
                    context,
                    "Delete ${widget.name}?",
                    "Are you sure you want to delete ${widget.parseElement(element)}?",
                    () => widget.databaseRef.child(element).remove(),
                  ),
                );
              },
              child: const Text('delete'),
            ),
          ),
        ],
      ),
    );
  }

  Widget listOfElements() {
    if (widget.elements.isEmpty) {
      return Center(
        child: Text(
          'No ${widget.name}s',
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 69 * 2),
      itemCount: widget.elements.length,
      itemBuilder: (BuildContext context, int index) {
        return singleListElement(widget.elements[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double bodyWidth;
    if (screenWidth < 1000) {
      bodyWidth = screenWidth - 32;
    } else if (screenWidth < 1300) {
      bodyWidth = screenWidth * 0.8;
    } else if (screenWidth < 1700) {
      bodyWidth = screenWidth * 0.8 - 320;
    } else {
      bodyWidth = 1000;
    }

    return ScrollConfiguration(
      behavior: MouseDragScrollBehavior(),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: bodyWidth,
            ),
            child: listOfElements(),
          ),
        ),
      ),
    );
  }
}
