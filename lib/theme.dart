import 'package:flutter/material.dart';

ThemeData catpuccinTheme(Map<String, Color> colors) {
  Color primaryColor = colors['mauve']!;
  Color secondaryColor = colors['pink']!;
  Color redColor = colors['red']!;
  Color lavenderColor = colors['lavender']!;
  Color baseColor = colors['base']!;
  Color crustColor = colors['crust']!;
  Color surface0Color = colors['surface0']!;
  Color surface1Color = colors['surface1']!;
  Color surface2Color = colors['surface2']!;
  Color overlay2Color = colors['overlay2']!;
  Color mantleColor = colors['mantle']!;
  Color textColor = colors['text']!;
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      background: baseColor,
      brightness: Brightness.light,
      primary: crustColor,
      secondary: mantleColor,
      surface: surface0Color,
      error: surface2Color,
      onBackground: textColor,
      onError: redColor,
      onSurface: textColor,
      onPrimary: primaryColor,
      onSecondary: secondaryColor,
      tertiary: surface1Color,
      onTertiary: lavenderColor,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: textColor,
      displayColor: primaryColor,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withAlpha(128),
      selectionHandleColor: primaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: overlay2Color,
      foregroundColor: baseColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primaryColor),
        foregroundColor: WidgetStatePropertyAll(baseColor),
      ),
    ),
    // iconButtonTheme: IconButtonThemeData(
    //   style: ButtonStyle(
    //     iconColor: MaterialStatePropertyAll(secondaryColor),
    //   ),
    // ),
    appBarTheme: AppBarTheme(
      backgroundColor: baseColor,
      foregroundColor: textColor,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: baseColor,
      unselectedIconTheme: IconThemeData(color: textColor),
      selectedIconTheme: IconThemeData(color: primaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      backgroundColor: baseColor,
      unselectedItemColor: textColor,
    ),
  );
}

// rgb(220, 138, 120)
// rgb(221, 120, 120)
// rgb(234, 118, 203)
// rgb(136, 57, 239)
// rgb(210, 15, 57)
// rgb(230, 69, 83)
// rgb(254, 100, 11)
// rgb(223, 142, 29)
// rgb(64, 160, 43)
// rgb(23, 146, 153)
// rgb(4, 165, 229)
// rgb(32, 159, 181)
// rgb(30, 102, 245)
// rgb(114, 135, 253)
// rgb(76, 79, 105)
// rgb(92, 95, 119)
// rgb(108, 111, 133)
// rgb(124, 127, 147)
// rgb(140, 143, 161)
// rgb(156, 160, 176)
// rgb(172, 176, 190)
// rgb(188, 192, 204)
// rgb(204, 208, 218)
// rgb(239, 241, 245)
// rgb(230, 233, 239)
// rgb(220, 224, 232)
const Map<String, Color> catppuccinLatteColors = {
  'rosewater': Color.fromARGB(255, 220, 138, 120),
  'flamingo': Color.fromARGB(255, 221, 120, 120),
  'pink': Color.fromARGB(255, 234, 118, 203),
  'mauve': Color.fromARGB(255, 136, 57, 239),
  'red': Color.fromARGB(255, 210, 15, 57),
  'maroon': Color.fromARGB(255, 230, 69, 83),
  'peach': Color.fromARGB(255, 254, 100, 11),
  'yellow': Color.fromARGB(255, 223, 142, 29),
  'green': Color.fromARGB(255, 64, 160, 43),
  'teal': Color.fromARGB(255, 23, 146, 153),
  'sky': Color.fromARGB(255, 4, 165, 229),
  'sapphire': Color.fromARGB(255, 32, 159, 181),
  'blue': Color.fromARGB(255, 30, 102, 245),
  'lavender': Color.fromARGB(255, 114, 135, 253),
  'text': Color.fromARGB(255, 76, 79, 105),
  'subtext1': Color.fromARGB(255, 92, 95, 119),
  'subtext0': Color.fromARGB(255, 108, 111, 133),
  'overlay2': Color.fromARGB(255, 124, 127, 147),
  'overlay1': Color.fromARGB(255, 140, 143, 161),
  'overlay0': Color.fromARGB(255, 156, 160, 176),
  'surface2': Color.fromARGB(255, 172, 176, 190),
  'surface1': Color.fromARGB(255, 188, 192, 204),
  'surface0': Color.fromARGB(255, 204, 208, 218),
  'base': Color.fromARGB(255, 239, 241, 245),
  'mantle': Color.fromARGB(255, 230, 233, 239),
  'crust': Color.fromARGB(255, 220, 224, 232),
};
// ThemeData catppuccinLatteTheme() {
//   Color primaryColor = catppuccinLatteColors['mauve']!;
//   Color secondaryColor = catppuccinLatteColors['pink']!;
//   return ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme(
//       background: catppuccinLatteColors['base']!,
//       brightness: Brightness.light,
//       primary: catppuccinLatteColors['crust']!,
//       secondary: catppuccinLatteColors['mantle']!,
//       surface: catppuccinLatteColors['surface0']!,
//       error: catppuccinLatteColors['surface2']!,
//       onBackground: catppuccinLatteColors['text']!,
//       onError: catppuccinLatteColors['red']!,
//       onSurface: catppuccinLatteColors['text']!,
//       onPrimary: primaryColor,
//       onSecondary: secondaryColor,
//     ),
//     textTheme: const TextTheme().apply(
//       bodyColor: catppuccinLatteColors['text']!,
//       displayColor: primaryColor,
//     ),
//     floatingActionButtonTheme: FloatingActionButtonThemeData(
//       elevation: 0,
//       backgroundColor: catppuccinLatteColors['overlay2']!,
//       foregroundColor: catppuccinLatteColors['base']!,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ButtonStyle(
//         backgroundColor: MaterialStatePropertyAll(primaryColor),
//         foregroundColor:
//             MaterialStatePropertyAll(catppuccinLatteColors['base']!),
//       ),
//     ),
//     // iconButtonTheme: IconButtonThemeData(
//     //   style: ButtonStyle(
//     //     iconColor: MaterialStatePropertyAll(secondaryColor),
//     //   ),
//     // ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: catppuccinLatteColors['base']!,
//       foregroundColor: catppuccinLatteColors['text']!,
//     ),
//     navigationRailTheme: NavigationRailThemeData(
//       backgroundColor: catppuccinLatteColors['base']!,
//       unselectedIconTheme: IconThemeData(color: catppuccinLatteColors['text']!),
//       selectedIconTheme: IconThemeData(color: primaryColor),
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       selectedItemColor: primaryColor,
//       backgroundColor: catppuccinLatteColors['base']!,
//       unselectedItemColor: catppuccinLatteColors['text']!,
//     ),
//   );
// }

// rgb(245, 224, 220)
// rgb(242, 205, 205)
// rgb(245, 194, 231)
// rgb(203, 166, 247)
// rgb(243, 139, 168)
// rgb(235, 160, 172)
// rgb(250, 179, 135)
// rgb(249, 226, 175)
// rgb(166, 227, 161)
// rgb(148, 226, 213)
// rgb(137, 220, 235)
// rgb(116, 199, 236)
// rgb(137, 180, 250)
// rgb(180, 190, 254)
// rgb(205, 214, 244)
// rgb(186, 194, 222)
// rgb(166, 173, 200)
// rgb(147, 153, 178)
// rgb(127, 132, 156)
// rgb(108, 112, 134)
// rgb(88, 91, 112)
// rgb(69, 71, 90)
// rgb(49, 50, 68)
// rgb(30, 30, 46)
// rgb(24, 24, 37)
// rgb(17, 17, 27)
const Map<String, Color> catppuccinMochaColors = {
  'rosewater': Color.fromARGB(255, 245, 224, 220),
  'flamingo': Color.fromARGB(255, 242, 205, 205),
  'pink': Color.fromARGB(255, 245, 194, 231),
  'mauve': Color.fromARGB(255, 203, 166, 247),
  'red': Color.fromARGB(255, 243, 139, 168),
  'maroon': Color.fromARGB(255, 235, 160, 172),
  'peach': Color.fromARGB(255, 250, 179, 135),
  'yellow': Color.fromARGB(255, 249, 226, 175),
  'green': Color.fromARGB(255, 166, 227, 161),
  'teal': Color.fromARGB(255, 148, 226, 213),
  'sky': Color.fromARGB(255, 137, 220, 235),
  'sapphire': Color.fromARGB(255, 116, 199, 236),
  'blue': Color.fromARGB(255, 137, 180, 250),
  'lavender': Color.fromARGB(255, 180, 190, 254),
  'text': Color.fromARGB(255, 205, 214, 244),
  'subtext1': Color.fromARGB(255, 186, 194, 222),
  'subtext0': Color.fromARGB(255, 166, 173, 200),
  'overlay2': Color.fromARGB(255, 147, 153, 178),
  'overlay1': Color.fromARGB(255, 127, 132, 156),
  'overlay0': Color.fromARGB(255, 108, 112, 134),
  'surface2': Color.fromARGB(255, 88, 91, 112),
  'surface1': Color.fromARGB(255, 69, 71, 90),
  'surface0': Color.fromARGB(255, 49, 50, 68),
  'base': Color.fromARGB(255, 30, 30, 46),
  'mantle': Color.fromARGB(255, 24, 24, 37),
  'crust': Color.fromARGB(255, 17, 17, 27),
};

// ThemeData catppuccinMochaTheme() {
//   Color primaryColor = catppuccinMochaColors['mauve']!;
//   Color secondaryColor = catppuccinMochaColors['pink']!;
//   return ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme(
//       background: catppuccinMochaColors['base']!,
//       brightness: Brightness.dark,
//       primary: catppuccinMochaColors['crust']!,
//       secondary: catppuccinMochaColors['mantle']!,
//       surface: catppuccinMochaColors['surface0']!,
//       error: catppuccinMochaColors['surface2']!,
//       onBackground: catppuccinMochaColors['text']!,
//       onError: catppuccinMochaColors['red']!,
//       onSurface: catppuccinMochaColors['text']!,
//       onPrimary: primaryColor,
//       onSecondary: secondaryColor,
//     ),
//     textTheme: const TextTheme().apply(
//       bodyColor: catppuccinMochaColors['text']!,
//       displayColor: primaryColor,
//     ),
//     floatingActionButtonTheme: FloatingActionButtonThemeData(
//       elevation: 0,
//       backgroundColor: catppuccinMochaColors['overlay2']!,
//       foregroundColor: catppuccinMochaColors['base']!,
//     ),
//     // iconButtonTheme: IconButtonThemeData(
//     //   style: ButtonStyle(
//     //     iconColor: MaterialStatePropertyAll(secondaryColor),
//     //   ),
//     // ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: catppuccinMochaColors['base']!,
//       foregroundColor: catppuccinMochaColors['text']!,
//     ),
//     navigationRailTheme: NavigationRailThemeData(
//       backgroundColor: catppuccinMochaColors['base']!,
//       unselectedIconTheme: IconThemeData(color: catppuccinMochaColors['text']!),
//       selectedIconTheme: IconThemeData(color: primaryColor),
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       selectedItemColor: primaryColor,
//       backgroundColor: catppuccinMochaColors['base']!,
//       unselectedItemColor: catppuccinMochaColors['text']!,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ButtonStyle(
//         backgroundColor: MaterialStatePropertyAll(primaryColor),
//         foregroundColor:
//             MaterialStatePropertyAll(catppuccinMochaColors['base']!),
//       ),
//     ),
//   );
// }

ThemeData oldLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.deepPurple,
    ),
    splashColor: Colors.purple,
    hoverColor: Colors.purple.shade200,
  );
}

ThemeData oldDarkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.deepPurple,
    ),
    hoverColor: Colors.purple.shade200,
    splashColor: Colors.purple,
    scaffoldBackgroundColor: const Color.fromARGB(255, 29, 27, 30),
  );
}
