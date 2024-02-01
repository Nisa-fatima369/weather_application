import 'package:flutter/material.dart';
import 'package:weather_application/screens/home.dart';
import 'package:weather_application/screens/saved_locations.dart';
import 'package:weather_application/screens/searrch.dart';
import 'package:weather_application/screens/splash_screen.dart';
import 'package:weather_application/theme/theme.dart';

void main() {
  runApp(
    const MainApp()
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        '/first': (context) =>  const Home(),
        '/second': (context) =>  const SearchScreen(),
        '/third': (context) => const SavedLocation(),
      },
      initialRoute: '/',
    );
  }
}
