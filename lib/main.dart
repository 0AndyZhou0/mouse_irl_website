import 'package:flutter/material.dart';
import 'package:mouse_irl_website/screens/home.dart';
import 'package:mouse_irl_website/screens/calendar.dart';
import 'package:mouse_irl_website/screens/user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
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
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CalendarPage(),
    UserPage(),
  ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // textTheme: const TextTheme(
        //   bodyMedium: TextStyle(
        //     color: Color.fromARGB(255, 214, 202, 152),
        //   )
        // ),
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Title!!!!!:3'),
        //   foregroundColor: Colors.white,
        // ),
        
        // drawer: Builder(
        //   builder: (context) {
        //     return Drawer(
        //       child: ListView(
        //         padding: EdgeInsets.zero,
        //         children: [
        //           UserAccountsDrawerHeader(
        //             accountName: const Text('Mouse'),
        //             accountEmail: const Text('Mouse@Mouse.Mouse'),
        //             currentAccountPicture: CircleAvatar(
        //               backgroundColor: Theme.of(context).colorScheme.background,
        //               child: const Text('M'),
        //             ),
        //             // onDetailsPressed: () {
        //             //   _onItemTapped(2);
        //             //   Navigator.pop(context);
        //             // },
        //           ),
        //           ListTile(
        //             leading: const Icon(Icons.home),
        //             title: const Text('Home'),
        //             selected: _selectedIndex == 0,
        //             onTap: () {
        //               _onItemTapped(0);
        //               Navigator.pop(context);
        //             },
        //           ),
        //           ListTile(
        //             leading: const Icon(Icons.calendar_today),
        //             title: const Text('Calendar'),
        //             selected: _selectedIndex == 1,
        //             onTap: () {
        //               _onItemTapped(1);
        //               Navigator.pop(context);
        //             },
        //           ),
        //           ListTile(
        //             leading: const Icon(Icons.person),
        //             title: const Text('User'),
        //             selected: _selectedIndex == 2,
        //             onTap: () {
        //               _onItemTapped(2);
        //               Navigator.pop(context);
        //             },
        //           ),
        //         ],
        //       )
        //     );
        //   }
        // ),
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