import 'package:flutter/material.dart';
import 'package:mouse_irl_website/database.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

TextEditingController _eventNameController = TextEditingController();

class _AddEventState extends State<AddEvent> {
  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      obscureText: title == 'Password' ? true : false,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget addEventButton() {
    return ElevatedButton(
        child: const Text('Add Event'),
        onPressed: () {
          Database().addEvent(_eventNameController.text);
          Navigator.pop(context);
        }
      );
  }

  Widget addEventForm() {
    return Column(
      children: [
        _entryField("Event Name", _eventNameController),
        addEventButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: addEventForm(),
      ),
    );
  }
}