import 'package:flutter/material.dart';
import 'package:lab4/screens/calendar.dart';
import 'package:lab4/providers/exam_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExamProvider(),
      child: MaterialApp(
        title: "Exam Calendar",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const CalendarScreen(),
      ),
    );
  }
}