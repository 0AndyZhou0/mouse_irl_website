import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/database.dart';
import 'package:mouse_irl_website/screens/admin_event.dart';
import 'package:mouse_irl_website/screens/admin_time.dart';

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
      ),
      onPressed: () {
        Auth().signOut();
      },
      child: const Text('Sign Out'),
    );
  }

  Future<Widget> get _adminEventsPageButton async {
    if (await Database().isAdmin(user!.uid)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventsAdminPage()),
          );
        },
        child: const Text('Edit Events'),
      );
    }
    return Container();
  }

  Future<Widget> get _adminTimesPageButton async {
    if (await Database().isAdmin(user!.uid)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TimesAdminPage()),
          );
        },
        child: const Text('Edit Times'),
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
              future: _adminEventsPageButton,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                } else {
                  return const SizedBox.shrink();
                }
              },
              initialData: const Text('Loading :3'),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _adminTimesPageButton,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                } else {
                  return const SizedBox.shrink();
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
