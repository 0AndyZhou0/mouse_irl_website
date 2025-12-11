import 'package:flutter/material.dart';

Widget alertDialogYesNoMessage(
    BuildContext context, String title, String content, Function callback,
    {String yesText = "Yes", String cancelText = "Cancel"}) {
  return AlertDialog(title: Text(title), content: Text(content), actions: [
    TextButton(
      child: Text(
        yesText,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      onPressed: () {
        callback();
        Navigator.of(context).pop();
      },
    ),
    TextButton(
      child: Text(
        cancelText,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  ]);
}
