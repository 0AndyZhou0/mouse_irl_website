import 'package:flutter/material.dart';
import 'package:mouse_irl_website/screens/home.dart';
import 'package:mouse_irl_website/screens/calendar.dart';
// import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CalendarPage(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          title: const Text('Title!!!!!:3'),
        ),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: bottomNavBar(),
      )
    );
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mouse),
            label: 'Mouse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      );
  }
}