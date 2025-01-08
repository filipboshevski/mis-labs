import 'package:flutter/foundation.dart';
import 'package:lab4/models/exam.dart';

class ExamProvider with ChangeNotifier {
  final List<Exam> _exams = [];
  List<Exam> get exams => _exams;

  List<Exam> getExams(DateTime day) {
    return _exams.where((e) => e.date.year == day.year && e.date.month == day.month && e.date.day == day.day).toList();
  }

  void addExam(Exam exam) {
    _exams.add(exam);
    notifyListeners();
  }
}