import 'package:flutter/material.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/screens/login.dart';
import 'package:mouse_irl_website/screens/user.dart';

class UserWidgetTree extends StatefulWidget {
  const UserWidgetTree({super.key});

  @override
  State<UserWidgetTree> createState() => UserWidgetTreeState();
}

class UserWidgetTreeState extends State<UserWidgetTree> {
  Widget page = const Scaffold();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          page = const UserPage();
        } else if (!Auth().isLoggedIn()) {
          page = const LoginPage();
        } else {
          page = const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return page;
      },
    );
  }
}
