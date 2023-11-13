import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        Auth().sendPasswordResetEmail(email: _emailController.text);
      },
      child: const Text('Submit'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/catbot.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            _entryField('Email', _emailController),
            const SizedBox(
              height: 10,
            ),
            _submitButton(),
          ],
        ),
      ),
    );
  }
}
