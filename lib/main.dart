import 'package:flutter/material.dart';
import 'package:mouse_irl_website/screens/home.dart';
import 'package:mouse_irl_website/screens/calendar.dart';
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

class Page {
  const Page({
    required this.page,
    required this.name,
    required this.icon,
    required this.selectedIcon,
  });
  final Widget page;
  final String name;
  final Widget icon;
  final Widget selectedIcon;
}

List<Page> _pages = [
  const Page(
    page: HomePage(),
    name: 'Home',
    icon: Icon(Icons.home),
    selectedIcon: Icon(Icons.home),
  ),
  const Page(
    page: CalendarPage(),
    name: 'Calendar',
    icon: Icon(Icons.mouse_outlined),
    selectedIcon: Icon(Icons.mouse),
  ),
  const Page(
    page: UserWidgetTree(),
    name: 'User',
    icon: Icon(Icons.person),
    selectedIcon: Icon(Icons.person),
  ),
];

class _MyAppState extends State<MyApp> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool _isExtended = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mouse_irl',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.deepPurple,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ),
      ),
      themeMode: ThemeMode.system,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Scaffold(
              body: _pages[_selectedIndex].page,
              bottomNavigationBar: bottomNavBar(),
            );
          } else {
            return Scaffold(
              key: scaffoldKey,
              appBar: appbar() as PreferredSizeWidget,
              body: Row(
                children: [
                  navRail(),
                  Expanded(child: _pages[_selectedIndex].page),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      items: _pages
          .map(
            (page) => BottomNavigationBarItem(
              icon: page.icon,
              activeIcon: page.selectedIcon,
              label: page.name,
            ),
          )
          .toList(),
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
    );
  }

  Widget navRail() {
    return NavigationRail(
      minWidth: 50,
      minExtendedWidth: 200,
      extended: _isExtended,
      labelType: _isExtended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      destinations: _pages
          .map(
            (page) => NavigationRailDestination(
              icon: page.icon,
              label: Text(page.name),
              selectedIcon: page.selectedIcon,
            ),
          )
          .toList(),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
    );
  }

  Widget appbar() {
    return AppBar(
      // title: const Text('mouse_irl'),
      leading: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: IconButton(
            icon: const Icon(Icons.menu),
            // onPressed: Scaffold.of(context).openDrawer,
            onPressed: () {
              setState(() {
                _isExtended = !_isExtended;
              });
            },
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        );
      }),
      shadowColor: Colors.transparent,
    );
  }
}
