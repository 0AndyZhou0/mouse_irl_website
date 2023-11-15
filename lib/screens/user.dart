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

  Widget _adminEventsPageButton() {
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

  Widget _adminTimesPageButton() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userEmail(),
            const SizedBox(height: 20),
            FutureBuilder(
              future: Database().isAdmin(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Column(children: [
                    _adminEventsPageButton(),
                    const SizedBox(height: 20),
                    _adminTimesPageButton(),
                  ]);
                } else {
                  return const SizedBox.shrink();
                }
              },
              initialData: const Text('Loading :3'),
            ),
            const SizedBox(height: 20),
            _userSignOutButton(),
          ],
        ),
      ),
    );
  }
}
