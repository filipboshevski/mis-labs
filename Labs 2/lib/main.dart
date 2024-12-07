import 'package:flutter/material.dart';
import 'package:lab2/screens/home.dart';
import 'package:lab2/screens/jokes_by_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '211092 Jokes App',
      initialRoute: '/',
      routes: {
        '/' : (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/joke_details') {
          final String jokeType = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => JokesByType(jokeType: jokeType),
          );
        }
        return null;
      },
    );
  }
}