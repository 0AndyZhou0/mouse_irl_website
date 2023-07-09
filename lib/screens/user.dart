import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mouse_irl_website/auth.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final User? user = Auth().currentUser;

  Widget _title() {
    return const Text(
      'mouse_irl login',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  Widget _userEmail() {
    return Text(user?.email ?? '');
  }

  Widget _userSignOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        Auth().signOut();
      },
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userEmail(),
            const SizedBox(height: 20),
            _userSignOutButton(),
          ],
        ),
      ),
    );
  }
}