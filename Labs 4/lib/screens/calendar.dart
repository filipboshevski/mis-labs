import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab4/providers/exam_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../models/exam.dart';
import 'add_exam.dart';
import 'map.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  var format = CalendarFormat.month;

  var focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                this.format = format;
              });
            },
            eventLoader: (day) {
              return context.read<ExamProvider>().getExams(day);
            },
          ),
          Expanded(
            child: Consumer<ExamProvider>(
              builder: (context, examProvider, child) {
                final List<Exam> exams = selectedDay != null ? examProvider.getExams(selectedDay!) : [];
                
                return ListView.builder(
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];

                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exam.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Exam date: ${DateFormat('dd/MM/yyyy HH:mm').format(exam.date).toString()}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'Exam location: ${exam.location}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Click here for location',
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(exam: exam),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExamScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
