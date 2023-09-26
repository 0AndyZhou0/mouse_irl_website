import 'package:flutter/material.dart';
import 'package:mouse_irl_website/screens/home.dart';
import 'package:mouse_irl_website/screens/calendar.dart';
import 'package:mouse_irl_website/screens/subbox.dart';
import 'package:mouse_irl_website/screens/user_widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mouse_irl_website/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    // CalendarPage(),
    SubBoxPage(),
    UserWidgetTree(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'mouse_irl',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 101, 90, 124),
            onPrimary: Colors.black,
            secondary: Color.fromARGB(255, 171, 146, 191),
            onSecondary: Colors.black,
            tertiary: Color.fromARGB(255, 175, 193, 214),
            onTertiary: Colors.black,
            background: Color.fromARGB(255, 206, 249, 242),
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            error: Colors.red,
            onError: Colors.black,
          ),
        ),
        home: Scaffold(
          body: _pages.elementAt(_selectedIndex),
          bottomNavigationBar: bottomNavBar(),
        ));
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mouse_outlined),
          activeIcon: Icon(Icons.mouse),
          label: 'Mouse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
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
