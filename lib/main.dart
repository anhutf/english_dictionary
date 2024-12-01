import 'package:english_dictionary/screens/home.dart';
import 'package:english_dictionary/screens/word.dart';
import 'package:flutter/material.dart';
// import 'package:english_dictionary/screens/home.dart';

import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.white,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: theme,
      home: HomeScreen(),
    );
  }
}
