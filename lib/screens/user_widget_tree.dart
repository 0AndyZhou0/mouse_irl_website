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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder:(context, snapshot) {
        if (snapshot.hasData) {
          return const UserPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}