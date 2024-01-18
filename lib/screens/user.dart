import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/database.dart';
import 'package:mouse_irl_website/screens/admin_event.dart';
import 'package:mouse_irl_website/screens/admin_time.dart';

// TODO: merge user page with home page
// Profile goes in the corner
// Edit buttons directly on voting boxes

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

  Widget _userProfilePicture() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(user?.photoURL ?? ''),
    );
  }

  Widget _userName() {
    return Text(user?.displayName ?? '');
  }

  Widget _userProfileEditButton() {
    return IconButton(
      onPressed: () {
        final TextEditingController _controller = TextEditingController();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: SizedBox(
              height: 150,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Enter new username"),
                    controller: _controller,
                  ),
                  // Add a file picker here for the profile picture
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  print(_controller.text);
                  Auth().updateUserProfile(name: _controller.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.edit),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
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
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _userProfilePicture(),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _userName(),
                        _userEmail(),
                      ],
                    ),
                    _userProfileEditButton(),
                  ],
                ),
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
        ),
      ),
    );
  }
}
