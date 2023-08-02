import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/screens/admin.dart';

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

  Future<bool> isAdmin(String uid) async {
    final ref = FirebaseDatabase.instance.ref('admins');
    final event = await ref.once(DatabaseEventType.value);
    return (event.snapshot.value as List).contains(uid);
  }

  Future<Widget> get _adminPageButton async {
    if (await isAdmin(user!.uid)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        },
        child: const Text('Edit Events'),
      );
    }
    return Container();
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
            FutureBuilder(
              future: _adminPageButton,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                } else {
                  return const SizedBox(height: 0);
                }
              },
            ),
            const SizedBox(height: 20),
            _userSignOutButton(),
          ],
        ),
      ),
    );
  }
}